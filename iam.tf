resource "aws_iam_account_alias" "alias" {
  account_alias = var.aws_account_alias
  count         = var.aws_account_alias == "" ? 0 : 1
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "deploy_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = concat(
        var.allow_assume_deploy_role, [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      )
    }
  }
}

resource "aws_iam_role" "upload_lambda_role" {
  name = var.code_repo_upload_role_name
  assume_role_policy = data.aws_iam_policy_document.deploy_role_assume.json
}
