variable "code_repo_name" {
  description = "Name of code repository, for example your-project-lambdas"
}

variable "code_repo_upload_role_name" {
  default = "upload-lambda"
}

variable "allow_code_repo_read_access" {
  type = list(string)
  default = []
}

variable "allow_assume_deploy_role" {
  type = list(string)
  default = []
}

variable "aws_account_alias" {
  type        = string
  default     = ""
  description = "Set custom AWS account alias"
}
