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
  profile = "stax-stax-au1-versent-innovation"
  region  = "ap-southeast-2"
}

# SES Domain Identity
resource "aws_ses_domain_identity" "workday" {
    for_each = var.identities
  domain = each.value["domain"]
}

# SES domain MAIL FROM
resource "aws_ses_domain_mail_from" "workday" {
    for_each = var.identities
  domain           = each.value["domain"]
  mail_from_domain = "mail.${each.value["domain"]}"
}

resource "aws_ses_domain_dkim" "workday" {
  for_each = var.identities
  domain = each.value["domain"]
}

resource "aws_iam_user" "smtpuser" {
  name = var.smtpuser
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
            "Resource": "test.versentpoc.com",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ]
        },
                {
            "Sid": "AuthoriseSatx",
            "Effect": "Allow",
            "Resource": "staxtest.versentpoc.com",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ]
        }
    ]
}
EOF
}

# output "testversentpoc_dkim" {
#   for_each = var.identities
#   value = aws_ses_domain_dkim.testversentpoc.dkim_tokens
# }

# output "testversentpoc_domainver" {
#   value = aws_ses_domain_identity.testversentpoc.verification_token
# }

# output "aws_iam_access_key_id" {
#     value = aws_iam_access_key.smtpuser.id
# }

# output "aws_iam_smtp_password_v4" {
#   value = aws_iam_access_key.smtpuser.ses_smtp_password_v4
#   sensitive = true
# }