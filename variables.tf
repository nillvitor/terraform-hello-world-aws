variable "aws_region" {
  description = "Região da AWS para provisionar os recursos."
  type        = string
  default     = "us-east-1"
}

variable "ec2_key_name" {
  description = "Nome da chave EC2 (.pem) para acesso SSH à instância."
  type        = string
}

variable "tag_name" {
  description = "Nome base para ser usado nas tags dos recursos."
  type        = string
  default     = "webserver"
}
