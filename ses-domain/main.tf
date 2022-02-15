terraform {
  required_providers {
    # Setting the AWS provider and version
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  # Setting the required Terraform version
  required_version = ">= 0.14.9"
}

# Setting the AWS region we want to use
provider "aws" {
  profile = var.profile
  region  = "ap-southeast-2"
}

# SES Domain Identity
resource "aws_ses_domain_identity" "workday" {
  for_each = var.identities
  domain   = each.value["domain"]
}

# Force a delay to ensure the Domain Identities exist
resource "time_sleep" "wait" {
  create_duration = "30s"

  depends_on = [aws_ses_domain_identity.workday]
}

# SES domain MAIL FROM
resource "aws_ses_domain_mail_from" "workday" {
  for_each         = var.identities
  domain           = each.value["domain"]
  mail_from_domain = "mail.${each.value["domain"]}"

  depends_on = [time_sleep.wait]
}

# Generate the DKIM records for the domains
resource "aws_ses_domain_dkim" "workday" {
  for_each = var.identities
  domain   = each.value["domain"]
}

# IAM User for SMTP
resource "aws_iam_user" "smtpuser" {
  name = var.smtpuser
  tags = {
    Description = "SES SMTP User for workday integration"
  }
}

# Access key for SMTP IAM User
resource "aws_iam_access_key" "smtpuser" {
  user = aws_iam_user.smtpuser.name
}

# IAM Policy to allow email sending
resource "aws_iam_user_policy" "smtpuser_ses" {
  name   = "AllowSESSending"
  user   = aws_iam_user.smtpuser.name
  policy = data.aws_iam_policy_document.smtp_policy.json
}

# IAM Policy data
data "aws_iam_policy_document" "smtp_policy" {

  dynamic "statement" {
    for_each = aws_ses_domain_identity.workday
    content {

      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ]
      resources = [statement.value.arn]
    }
  }
}