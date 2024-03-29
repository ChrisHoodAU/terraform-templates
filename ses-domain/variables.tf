# Variable for the Domain identities to be created
variable "identities" {
  description = "Map of Domains to configuration"
  type        = map(any)
  default = {
    id1 = {
      domain = "prod.domain.com"
    },
    id2 = {
      domain = "prod.domain2.com"
    }
  }
}

# The IAM SMTP user to be created
variable "smtpuser" {
  description = "The name of the IAM user for SMTP"
  type        = string
  default     = "smtp-user"
}

# The AWS profile to use
variable "profile" {
  type    = string
  default = "aws-profile"
}