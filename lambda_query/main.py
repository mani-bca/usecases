import os
import json
import logging
import boto3
import psycopg2

logger = logging.getLogger()
logger.setLevel(logging.INFO)

REGION = os.environ.get("AWS_REGION", "us-east-1")
SECRET_NAME = os.environ["DB_SECRET_NAME"]
MODEL_ID = "amazon.titan-embed-text-v2" 

def get_db_credentials():
    client = boto3.client('secretsmanager', region_name=REGION)
    secret = client.get_secret_value(SecretId=SECRET_NAME)
    return json.loads(secret['SecretString'])

def connect_db():
    creds = get_db_credentials()
    logger.info("Connecting to PostgreSQL DB")
    return psycopg2.connect(
        host=creds['host'],
        database=creds['dbname'],
        user=creds['username'],
        password=creds['password'],
        port=creds['port']
    )

def get_titan_embedding(text):
    logger.info("Calling Amazon Titan embedding model")
    client = boto3.client("bedrock-runtime", region_name=REGION)
    payload = {
        "inputText": text
    }
    response = client.invoke_model(
        modelId=MODEL_ID,
        contentType="application/json",
        accept="application/json",
        body=json.dumps(payload)
    )
    body = json.loads(response['body'].read())
    return body["embedding"]

def lambda_handler(event, context):
    try:
        logger.info("Parsing input event")
        body = json.loads(event.get("body", "{}"))
        query = body.get("query")

        if not query:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'query'"})
            }

        embedding = get_titan_embedding(query)

        conn = connect_db()
        cur = conn.cursor()

        logger.info("Executing pgvector semantic search query")
        cur.execute("""
            SELECT chunk, embedding <#> %s AS score
            FROM documents
            WHERE embedding IS NOT NULL
            ORDER BY score ASC
            LIMIT 5;
        """, (embedding,))

        results = [{"chunk": row[0], "score": row[1]} for row in cur.fetchall()]
        cur.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({"results": results})
        }

    except Exception as e:
        logger.exception("Unhandled error in lambda")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }