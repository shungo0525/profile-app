variable "app_name" {
  description = "アプリ名"
  type        = "string"

  default = "loof-api-server"
}

variable "domain" {
  description = "Route 53 で管理しているドメイン"
  type        = "string"

  default = "api-stg.loof-admin.com"
}

variable "environment" {
  description = "環境"
  type        = "string"

  default = "stg"
}

variable "access_key" {
  description = "AWSのアクセスキー"
}

variable "secret_key" {
  description = "AWSのアクセスキー"
}

variable "public_key_stg" {
  description = "STG環境のパブリックキー"
}
