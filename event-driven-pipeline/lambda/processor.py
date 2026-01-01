import json
import boto3
import uuid
import logging

# Enable logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('event-data-table')

def lambda_handler(event, context):
    logger.info("Lambda triggered with event")

    try:
        for record in event.get('Records', []):
            body = record.get('body', '{}')
            data = json.loads(body)

            table.put_item(
                Item={
                    'id': str(uuid.uuid4()),
                    'eventType': data.get('eventType', 'unknown'),
                    'timestamp': data.get('timestamp', 'unknown')
                }
            )

        logger.info("Event processed successfully")

        return {
            'statusCode': 200,
            'body': 'Event processed successfully'
        }

    except Exception as e:
        logger.error(f"Error processing event: {str(e)}")
        raise
