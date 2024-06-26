import json
import boto3
import os
import logging

s3 = boto3.client('s3')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info('Received event: %s', json.dumps(event))
    bucket_name = os.environ['BUCKET_NAME']
    try:
        if event['httpMethod'] != 'GET' or event['path'] != '/lambda/get-objects':
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Not Found'}),
                'headers': {'Content-Type': 'application/json'}
            }

        continuation_token = event.get('queryStringParameters', {}).get('continuationToken')
        if continuation_token:
            response = s3.list_objects_v2(Bucket=bucket_name, MaxKeys=1000, ContinuationToken=continuation_token)
        else:
            response = s3.list_objects_v2(Bucket=bucket_name, MaxKeys=1000)

        objects = [content['Key'] for content in response.get('Contents', [])]
        next_continuation_token = response.get('NextContinuationToken')

        return {
            'statusCode': 200,
            'body': json.dumps({
                'objects': objects,
                'nextContinuationToken': next_continuation_token
            }),
            'headers': {'Content-Type': 'application/json'}
        }
    except Exception as e:
        logger.error(f"Error fetching objects from S3: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal Server Error'}),
            'headers': {'Content-Type': 'application/json'}
        }
