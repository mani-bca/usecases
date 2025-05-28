import boto3
import os
import psycopg2
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

REGION = os.environ.get("AWS_REGION", "us-east-1")
SECRET_NAME = os.environ["DB_SECRET_NAME"]
BEDROCK_MODEL_ID = "anthropic.claude-v2"  # Example Claude model
BEDROCK_REGION = "us-east-1"

def get_db_credentials():
    sm = boto3.client("secretsmanager", region_name=REGION)
    sec = sm.get_secret_value(SecretId=SECRET_NAME)
    return eval(sec["SecretString"])

def connect_db():
    creds = get_db_credentials()
    return psycopg2.connect(
        host=creds["host"],
        database=creds["dbname"],
        user=creds["username"],
        password=creds["password"],
        port=creds["port"],
    )

def ask_claude(query):
    bedrock = boto3.client("bedrock-runtime", region_name=BEDROCK_REGION)
    prompt = f"\n\nHuman: Give a short summary or refined version of this question for document matching: {query}\n\nAssistant:"
    
    response = bedrock.invoke_model(
        modelId=BEDROCK_MODEL_ID,
        contentType="application/json",
        accept="application/json",
        body=json.dumps({
            "prompt": prompt,
            "max_tokens_to_sample": 100,
            "temperature": 0.5,
        })
    )
    result = json.loads(response["body"].read().decode())
    return result.get("completion", "").strip()

def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))
        query = body.get("query")
        if not query:
            return {"statusCode": 400, "body": json.dumps({"error": "Missing query"})}

        logger.info(f"Received query: {query}")
        refined = ask_claude(query)
        logger.info(f"Refined by Claude: {refined}")

        # OPTIONAL: convert to embedding or just use keyword search
        conn = connect_db()
        cur = conn.cursor()

        logger.info("Running text similarity (ILIKE match)")
        cur.execute("""
            SELECT chunk FROM documents
            WHERE chunk ILIKE %s
            LIMIT 5;
        """, (f"%{refined}%",))

        rows = cur.fetchall()
        cur.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "query": query,
                "refined": refined,
                "matches": [row[0] for row in rows]
            })
        }

    except Exception as e:
        logger.exception("Error occurred")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }