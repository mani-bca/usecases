import boto3
import base64
import uuid

s3 = boto3.client('s3')
BUCKET_NAME = 'your-s3-bucket-name'

def lambda_handler(event, context):
    try:
        body = event['body']
        image_data = base64.b64decode(body)
        
        filename = f"{uuid.uuid4()}.jpg"
        
        s3.put_object(Bucket=BUCKET_NAME, Key=filename, Body=image_data, ContentType='image/jpeg')
        
        return {
            'statusCode': 200,
            'body': f"Image uploaded successfully as {filename}"
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: {str(e)}"
        }
