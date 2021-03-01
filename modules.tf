
module "coderepository" {
  source = "git::https://github.com/labd/terraform-aws-mach-code-repository.git"
  name   = var.code_repo_name

  access_principle_identifiers = var.allow_code_repo_read_access

  deploy_principle_identifiers = [
    aws_iam_role.upload_lambda_role.id,
  ]
}
