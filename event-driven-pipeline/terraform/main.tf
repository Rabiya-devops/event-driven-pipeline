############################################
# S3 Bucket (Event Source)
############################################
resource "aws_s3_bucket" "data_bucket" {
  bucket = "event-driven-data-bucket-12345"
}

############################################
# DynamoDB Table (Data Storage)
############################################
resource "aws_dynamodb_table" "events_table" {
  name         = "event-data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

############################################
# IAM Role for Lambda
############################################
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

############################################
# IAM Policies for Lambda
############################################
resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

############################################
# Lambda: Data Processor
############################################
resource "aws_lambda_function" "processor" {
  function_name = "data-processor"
  runtime       = "python3.9"
  handler       = "processor.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "../lambda/processor.zip"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.events_table.name
    }
  }
}

############################################
# Lambda: Daily Report Generator
############################################
resource "aws_lambda_function" "report" {
  function_name = "daily-report-generator"
  runtime       = "python3.9"
  handler       = "report_generator.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "../lambda/report_generator.zip"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.events_table.name
    }
  }
}

############################################
# CloudWatch Daily Schedule
############################################
resource "aws_cloudwatch_event_rule" "daily_report" {
  name                = "daily-report-schedule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "daily_report_target" {
  rule      = aws_cloudwatch_event_rule.daily_report.name
  target_id = "daily-report"
  arn       = aws_lambda_function.report.arn
}

############################################
# Permission for CloudWatch to Invoke Lambda
############################################
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatchInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_report.arn
}
