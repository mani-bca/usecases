import boto3
import os
import psycopg2
import fitz  # PyMuPDF
import tiktoken  # or use nltk if preferred

SECRET_NAME = os.environ['DB_SECRET_NAME']
REGION = os.environ.get('AWS_REGION', 'us-east-1')
S3_BUCKET = os.environ['RAW_BUCKET']

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

def chunk_text(text, max_tokens=500):
    tokenizer = tiktoken.get_encoding("cl100k_base")
    tokens = tokenizer.encode(text)
    chunks = [tokens[i:i+max_tokens] for i in range(0, len(tokens), max_tokens)]
    decoded_chunks = [tokenizer.decode(chunk) for chunk in chunks]
    return decoded_chunks

def lambda_handler(event, context):
    file_key = event.get('file_key')
    if not file_key:
        return {"error": "Missing 'file_key' in event"}

    s3 = boto3.client('s3')
    obj = s3.get_object(Bucket=S3_BUCKET, Key=file_key)
    pdf_bytes = obj['Body'].read()

    doc = fitz.open(stream=pdf_bytes, filetype="pdf")
    text = "\n".join(page.get_text() for page in doc)
    chunks = chunk_text(text)

    conn = connect_db()
    cur = conn.cursor()
    cur.execute(\"\"\"CREATE TABLE IF NOT EXISTS documents (
        id SERIAL PRIMARY KEY,
        chunk TEXT,
        embedding VECTOR(384)
    );\"\"\")

    for chunk in chunks:
        cur.execute("INSERT INTO documents (chunk, embedding) VALUES (%s, NULL)", (chunk,))

    conn.commit()
    cur.close()
    conn.close()

    return {"status": "success", "chunks_stored": len(chunks)}