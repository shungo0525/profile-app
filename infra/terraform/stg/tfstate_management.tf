resource "aws_s3_bucket" "terraform-state-storage" {
  bucket = "${var.app_name}-tfstate-${var.environment}"
  acl    = "private"
  region = "ap-northeast-1"

  versioning {
    enabled = true
  }
}

// TODO: lockするとエラーが出る
//resource "aws_dynamodb_table" "terraform-state-lock" {
//  name           = "${var.app_name}-tfstate-lock-${var.environment}"
//  read_capacity  = 1
//  write_capacity = 1
//  hash_key       = "LoofApiServerStg"
//
//  attribute {
//    name = "LoofApiServerStg"
//    type = "S"
//  }
//}

terraform {
  backend "s3" {
    bucket         = "loof-api-server-tfstate-stg"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
//    dynamodb_table = "loof-api-server-tfstate-lock-stg"
  }
}
