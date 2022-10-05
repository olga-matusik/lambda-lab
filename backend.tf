terraform {
  backend "s3" {
    bucket = "ta-terraform-tfstates-727250514989"
    key    = "terraform-lab/lambda/hello/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}