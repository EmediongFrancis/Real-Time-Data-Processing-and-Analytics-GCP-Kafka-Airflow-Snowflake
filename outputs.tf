output "kinesis_stream_arn" {
  value = aws_kinesis_stream.data_stream.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.process_kinesis.arn
}

output "elasticsearch_endpoint" {
  value = aws_elasticsearch_domain.elasticsearch_domain.endpoint
}

output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.lambda_log_group.name
}
