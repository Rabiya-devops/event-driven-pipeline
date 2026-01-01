Event-Driven Data Processing Pipeline on AWS-
Overview-

This project implements an event-driven data processing and automated reporting pipeline using AWS services. Incoming data events are captured automatically, processed using serverless compute, stored for analysis, and summarized into daily reports. The entire infrastructure is provisioned using Terraform and deployed via a CI/CD pipeline.

Architecture-

Amazon S3: Stores raw input data and generated reports

AWS Lambda: Processes incoming data and generates daily reports

Amazon DynamoDB: Stores processed event data

Amazon EventBridge: Triggers daily report generation

Terraform: Infrastructure as Code

GitHub Actions: CI/CD automation

Workflow-

A JSON file is uploaded to the raw S3 bucket

The upload event triggers the data processing Lambda function

Processed data is stored in DynamoDB

A scheduled Lambda function generates a daily summary report

The report is saved in the reports S3 bucket

Deployment
cd terraform
terraform init
terraform apply

CI/CD-

On every push to the main branch, GitHub Actions automatically deploys the infrastructure using Terraform.

Monitoring-

AWS CloudWatch is used for logging and monitoring Lambda executions.

Author


Rabiya Akram
