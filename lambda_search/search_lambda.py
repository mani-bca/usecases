import os
import boto3
import psycopg2

SECRET_NAME = os.environ['DB_SECRET_NAME']
REGION = os.environ.get('AWS_REGION', 'us-east-1')

def get_db_credentials():
    client = boto3.client('secretsmanager', region_name=REGION)
    secret = client.get_secret_value(SecretId=SECRET_NAME)
    return eval(secret['SecretString'])

def connect_db():
    creds = get_db_credentials()
    return psycopg2.connect(
        host=creds['host'],
        database=creds['dbname'],
        user=creds['username'],
        password=creds['password'],
        port=creds['port']
    )

def lambda_handler(event, context):
    query_vector = event.get("query_vector")
    if not query_vector or not isinstance(query_vector, list):
        return {"error": "Missing or invalid 'query_vector'"}

    conn = connect_db()
    cur = conn.cursor()
    cur.execute(\"\"\"
        SELECT chunk, embedding <#> %s AS score
        FROM documents
        WHERE embedding IS NOT NULL
        ORDER BY score
        LIMIT 5;
    \"\"\", (query_vector,))
    results = [{"chunk": row[0], "score": row[1]} for row in cur.fetchall()]
    cur.close()
    conn.close()

    return {"results": results}