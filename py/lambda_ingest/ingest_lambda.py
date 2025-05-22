import boto3
import os
import psycopg2
import fitz  # PyMuPDF
from sentence_transformers import SentenceTransformer

SECRET_NAME = os.environ['DB_SECRET_NAME']
REGION = os.environ.get('AWS_REGION', 'us-east-1')
S3_BUCKET = os.environ['RAW_BUCKET']

# Load embedding model
model = SentenceTransformer('all-MiniLM-L6-v2')

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
    s3 = boto3.client('s3')
    file_key = event['file_key']  # passed in event
    obj = s3.get_object(Bucket=S3_BUCKET, Key=file_key)
    doc_bytes = obj['Body'].read()

    # Parse PDF text
    pdf = fitz.open(stream=doc_bytes, filetype='pdf')
    full_text = "\n".join(page.get_text() for page in pdf)

    # Chunk text
    chunks = [full_text[i:i+512] for i in range(0, len(full_text), 512)]
    embeddings = model.encode(chunks)

    # Store in DB
    conn = connect_db()
    cur = conn.cursor()
    cur.execute(\"\"\"CREATE TABLE IF NOT EXISTS documents (
        id SERIAL PRIMARY KEY,
        chunk TEXT,
        embedding VECTOR(384)
    );\"\"\")
    for chunk, vector in zip(chunks, embeddings):
        cur.execute("INSERT INTO documents (chunk, embedding) VALUES (%s, %s)", (chunk, vector.tolist()))
    conn.commit()
    cur.close()
    conn.close()

    return {"status": "success", "chunks_inserted": len(chunks)}