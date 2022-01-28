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

variable "awsvars" {
  type = map(string)
  default = {
    domain   = "test.versentpoc.com"
    username = "workday-smtp-user"
  }
}

# Setting the AWS region we want to use
provider "aws" {
  profile = "stax-stax-au1-versent-innovation"
  region  = "ap-southeast-2"
}

# SES Domain Identity
resource "aws_ses_domain_identity" "testversentpoc" {
  domain = lookup(var.awsvars, "domain")
}

# SES domain MAIL FROM
resource "aws_ses_domain_mail_from" "testversentpoc" {
  domain           = aws_ses_domain_identity.testversentpoc.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.testversentpoc.domain}"
}

resource "aws_ses_domain_dkim" "testversentpoc" {
  domain = aws_ses_domain_identity.testversentpoc.domain
}

resource "aws_iam_user" "smtpuser" {
  name = lookup(var.awsvars, "username")

  tags = {
    Description = "SES SMTP User for workday integration"
  }
}

resource "aws_iam_access_key" "smtpuser" {
  user = aws_iam_user.smtpuser.name
}

resource "aws_iam_user_policy" "smtpuser_ses" {
  name = "AllowSESSending"
  user = aws_iam_user.smtpuser.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AuthoriseVersent",
            "Effect": "Allow",
            "Resource": "${aws_ses_domain_identity.testversentpoc.arn}",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ]
        }
    ]
}
EOF
}

# data "aws_iam_policy_document" "testversentpoc" {
#   statement {
#     actions   = ["SES:SendEmail", "SES:SendRawEmail"]
#     resources = [aws_ses_domain_identity.testversentpoc.arn]

#     principals {
#       identifiers = ["*"]
#       type        = "AWS"
#     }
#   }
# }

# resource "aws_ses_identity_policy" "example" {
#   identity = aws_ses_domain_identity.testversentpoc.arn
#   name     = "example"
#   policy   = data.aws_iam_policy_document.testversentpoc.json
# }

output "testversentpoc_dkim" {
  value = aws_ses_domain_dkim.testversentpoc.dkim_tokens
}

output "testversentpoc_domainver" {
  value = aws_ses_domain_identity.testversentpoc.verification_token
}

output "aws_iam_access_key_id" {
    value = aws_iam_access_key.smtpuser.id
}

output "aws_iam_smtp_password_v4" {
  value = aws_iam_access_key.smtpuser.ses_smtp_password_v4
  sensitive = true
}