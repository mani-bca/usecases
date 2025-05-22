import os
import json
import boto3
import psycopg2
import psycopg2.extras
import tempfile
import io
import re
import numpy as np
from typing import List, Dict, Any, Tuple

# For text extraction
import PyPDF2
import nltk
from nltk.tokenize import sent_tokenize

# For embedding generation
import openai

# Configure credentials
openai.api_key = os.environ.get("OPENAI_API_KEY")

# Database connection parameters
DB_HOST = os.environ.get("DB_HOST")
DB_PORT = os.environ.get("DB_PORT", "5432")
DB_NAME = os.environ.get("DB_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")

# Initialize AWS services
s3 = boto3.client('s3')

# Download NLTK resources (will be downloaded to /tmp in Lambda)
nltk.data.path.append("/tmp")
try:
    nltk.download('punkt', download_dir="/tmp")
except:
    pass

def get_db_connection():
    """Establish and return a database connection"""
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn

def setup_database():
    """Set up the database schema if it doesn't exist"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Create extension if not exists
    cursor.execute("CREATE EXTENSION IF NOT EXISTS vector;")
    
    # Create documents table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS documents (
        id SERIAL PRIMARY KEY,
        s3_bucket TEXT NOT NULL,
        s3_key TEXT NOT NULL,
        document_type TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    """)
    
    # Create chunks table with vector support
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS chunks (
        id SERIAL PRIMARY KEY,
        document_id INTEGER REFERENCES documents(id) ON DELETE CASCADE,
        chunk_index INTEGER NOT NULL,
        chunk_text TEXT NOT NULL,
        embedding vector(1536) NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    """)
    
    # Create index for faster vector searches
    cursor.execute("""
    CREATE INDEX IF NOT EXISTS chunks_embedding_idx ON chunks USING ivfflat (embedding vector_l2_ops)
    WITH (lists = 100);
    """)
    
    conn.commit()
    cursor.close()
    conn.close()

def extract_text_from_pdf(file_content: bytes) -> str:
    """Extract text from a PDF file"""
    with io.BytesIO(file_content) as pdf_file:
        reader = PyPDF2.PdfReader(pdf_file)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"
    return text

def extract_text_from_file(file_content: bytes, file_extension: str) -> str:
    """Extract text from different file types"""
    if file_extension.lower() == '.pdf':
        return extract_text_from_pdf(file_content)
    elif file_extension.lower() in ['.txt', '.md', '.csv']:
        return file_content.decode('utf-8', errors='replace')
    else:
        raise ValueError(f"Unsupported file type: {file_extension}")

def chunk_text(text: str, max_tokens: int = 500) -> List[str]:
    """
    Split text into chunks of approximately max_tokens.
    This is a simple implementation. For production, consider more sophisticated chunking.
    """
    # Clean up text
    text = re.sub(r'\s+', ' ', text).strip()
    
    # Split into sentences
    sentences = sent_tokenize(text)
    
    chunks = []
    current_chunk = []
    current_token_count = 0
    
    for sentence in sentences:
        # Rough estimate of tokens (words)
        sentence_token_count = len(sentence.split())
        
        if current_token_count + sentence_token_count > max_tokens and current_chunk:
            # Start a new chunk if we exceed the token limit
            chunks.append(" ".join(current_chunk))
            current_chunk = [sentence]
            current_token_count = sentence_token_count
        else:
            current_chunk.append(sentence)
            current_token_count += sentence_token_count
    
    # Add the last chunk if it's not empty
    if current_chunk:
        chunks.append(" ".join(current_chunk))
    
    return chunks

def generate_embedding(text: str) -> List[float]:
    """Generate embeddings using OpenAI API"""
    try:
        response = openai.Embedding.create(
            model="text-embedding-ada-002",
            input=text
        )
        return response["data"][0]["embedding"]
    except Exception as e:
        print(f"Error generating embedding: {e}")
        # Return a zero embedding as fallback (not ideal for production)
        return [0.0] * 1536

def store_document_and_chunks(s3_bucket: str, s3_key: str, document_type: str, 
                             chunks: List[str], embeddings: List[List[float]]) -> None:
    """Store document metadata and chunks with embeddings in the database"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Insert document
        cursor.execute(
            "INSERT INTO documents (s3_bucket, s3_key, document_type) VALUES (%s, %s, %s) RETURNING id;",
            (s3_bucket, s3_key, document_type)
        )
        document_id = cursor.fetchone()[0]
        
        # Insert chunks and embeddings
        for i, (chunk, embedding) in enumerate(zip(chunks, embeddings)):
            cursor.execute(
                "INSERT INTO chunks (document_id, chunk_index, chunk_text, embedding) VALUES (%s, %s, %s, %s);",
                (document_id, i, chunk, embedding)
            )
        
        conn.commit()
        print(f"Successfully stored document {s3_key} with {len(chunks)} chunks")
    except Exception as e:
        conn.rollback()
        print(f"Error storing document: {e}")
        raise e
    finally:
        cursor.close()
        conn.close()

def lambda_handler(event, context):
    """Process document when uploaded to S3"""
    # Ensure database is set up
    setup_database()
    
    # Get bucket and key from event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    print(f"Processing file: {key} from bucket: {bucket}")
    
    try:
        # Get file extension
        _, file_extension = os.path.splitext(key)
        
        # Download file from S3
        response = s3.get_object(Bucket=bucket, Key=key)
        file_content = response['Body'].read()
        
        # Extract text based on file type
        text = extract_text_from_file(file_content, file_extension)
        
        # Chunk the text
        chunks = chunk_text(text)
        
        # Generate embeddings for each chunk
        embeddings = [generate_embedding(chunk) for chunk in chunks]
        
        # Store document and chunks in database
        store_document_and_chunks(bucket, key, file_extension, chunks, embeddings)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Successfully processed {key}',
                'num_chunks': len(chunks)
            })
        }
    except Exception as e:
        print(f"Error processing file: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': f'Error processing {key}: {str(e)}'
            })
        }
