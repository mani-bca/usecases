import os
import json
import psycopg2
import psycopg2.extras
import openai
from typing import List, Dict, Any

# Configure credentials
openai.api_key = os.environ.get("OPENAI_API_KEY")

# Database connection parameters
DB_HOST = os.environ.get("DB_HOST")
DB_PORT = os.environ.get("DB_PORT", "5432")
DB_NAME = os.environ.get("DB_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")

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

def generate_embedding(query: str) -> List[float]:
    """Generate embedding for the search query"""
    try:
        response = openai.Embedding.create(
            model="text-embedding-ada-002",
            input=query
        )
        return response["data"][0]["embedding"]
    except Exception as e:
        print(f"Error generating embedding: {e}")
        raise e

def search_similar_chunks(embedding: List[float], limit: int = 5) -> List[Dict[str, Any]]:
    """Search for semantically similar chunks in the database"""
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    
    try:
        # Search for similar chunks using vector similarity
        cursor.execute("""
            SELECT 
                c.id, 
                c.chunk_text, 
                d.s3_bucket, 
                d.s3_key,
                1 - (c.embedding <-> %s) as similarity
            FROM 
                chunks c
            JOIN 
                documents d ON c.document_id = d.id
            ORDER BY 
                c.embedding <-> %s
            LIMIT %s;
        """, (embedding, embedding, limit))
        
        results = cursor.fetchall()
        return [dict(r) for r in results]
    finally:
        cursor.close()
        conn.close()

def lambda_handler(event, context):
    """Handle API Gateway search requests"""
    try:
        # Parse the request body
        body = json.loads(event.get('body', '{}'))
        query = body.get('query')
        limit = body.get('limit', 5)
        
        if not query:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'error': 'Query parameter is required'
                })
            }
        
        # Generate embedding for the query
        embedding = generate_embedding(query)
        
        # Search for similar chunks
        results = search_similar_chunks(embedding, limit)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'query': query,
                'results': results
            })
        }
    except Exception as e:
        print(f"Error processing request: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }