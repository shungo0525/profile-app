provider "terraform" {
  required_version = "= 0.12.28"
}

provider "aws" {
  version = "= 2.70.0"
  region = "ap-northeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
