import boto3
import base64
import uuid
import os

s3 = boto3.client('s3')
BUCKET_NAME = os.environ.get('BUCKET_NAME')  # Set via environment variable

def lambda_handler(event, context):
    try:
        # For HTTP API (v2), body might be base64-encoded
        body = event.get('body', '')
        is_base64 = event.get("isBase64Encoded", False)

        if is_base64:
            image_data = base64.b64decode(body)
        else:
            image_data = body.encode('utf-8')

        filename = f"{uuid.uuid4()}.jpg"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=image_data,
            ContentType='image/jpeg'
        )

        return {
            'statusCode': 200,
            'body': f"Image uploaded successfully as {filename}"
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: {str(e)}"
        }