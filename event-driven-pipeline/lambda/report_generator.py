import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('event-data')

def lambda_handler(event, context):
    response = table.scan()
    total_records = len(response['Items'])

    report = {
        "total_records": total_records
    }

    print("Daily Report:", json.dumps(report))
    return report
