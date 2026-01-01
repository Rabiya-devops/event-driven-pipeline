 Event-Driven Data Processing Pipeline-(AWS + Terraform)-
This project demonstrates a real-world event-driven architecture built on AWS using Terraform for Infrastructure as Code.
When a file is uploaded to an S3 bucket, it automatically triggers a Lambda function that processes the event and stores metadata in DynamoDB.

 Architecture-
User → S3 Bucket → AWS Lambda → DynamoDB

Flow:

A file is uploaded to an S3 bucket

S3 triggers a Lambda function

Lambda processes the event

Event data is stored in DynamoDB

Technologies Used-

AWS Services

S3 (Event source)

Lambda (Serverless compute)

DynamoDB (NoSQL database)

IAM (Roles & permissions)

CloudWatch (Logs)

Infrastructure as Code

Terraform

Project Structure
event-driven-pipeline/
├── .github/workflows/
│   └── deploy.yml
├── lambda/
│   ├── processor.py
│   └── report_generator.py
├── sample-data/
│   └── sample.json
├── terraform/
│   ├── main.tf
│   ├── variables.tf
├── .gitignore
├── README.md

Prerequisites-

AWS Account

AWS CLI configured

Terraform installed

Git & GitHub

Deployment Steps-
cd terraform
terraform init
terraform plan
terraform apply


How to Test (Demo)-

Upload a file to the S3 bucket:

echo "test event" > test.txt
aws s3 cp test.txt s3://<your-bucket-name>/


Verify data in DynamoDB:

aws dynamodb scan --table-name event-data-table


Check logs in CloudWatch → Lambda Logs

-Key Learnings

Event-driven cloud architecture

Serverless application design

Terraform best practices

IAM role & policy management

AWS service integration

Real-world DevOps workflow
