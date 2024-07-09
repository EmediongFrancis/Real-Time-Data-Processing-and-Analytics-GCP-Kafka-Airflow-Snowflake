resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.process_kinesis.function_name}"
  retention_in_days = 7
}

# CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name        = "lambda_error_alarm"
  alarm_description = "Alarm when the Lambda function encounters errors"
  namespace         = "AWS/Lambda"
  metric_name       = "Errors"
  dimensions = {
    FunctionName = aws_lambda_function.process_kinesis.function_name
  }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.sns_topic.arn]

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}
