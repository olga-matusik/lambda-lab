#policies for running lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/files/lambda_hello.zip"
  function_name = "lambda_hello"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"

  #for a security, fingerprint of the file, important!- make a reference to data source of archive_file
  source_code_hash = data.archive_file.lambda_hello_deployment.output_base64sha256

  #check the latest runtime for your code
  runtime = "python3.9"
}

#makes .zip file to archive the code there
data "archive_file" "lambda_hello_deployment" {
  type        = "zip"
  # ${path.module} isa path to the file
  source_file = "${path.module}/src/hello.py"
  output_path = "${path.module}/files/lambda_hello.zip"
}