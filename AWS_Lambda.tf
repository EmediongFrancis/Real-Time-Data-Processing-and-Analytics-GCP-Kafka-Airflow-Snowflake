resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "IAM policy for Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:ListStreams"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.data_bucket.arn}",
          "${aws_s3_bucket.data_bucket.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = "es:*",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "sns:Publish",
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Create Lambda function
resource "aws_lambda_function" "process_kinesis" {
  filename      = "lambda_function_payload.zip" # Replace with your Lambda deployment package
  function_name = "ProcessKinesisStream"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x" # Adjust runtime as needed

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment]
}

# Create Lambda event source mapping for Kinesis
resource "aws_lambda_event_source_mapping" "kinesis_lambda" {
  event_source_arn  = aws_kinesis_stream.data_stream.arn
  function_name     = aws_lambda_function.process_kinesis.arn
  starting_position = "LATEST"
}
