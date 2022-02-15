# Variable for the Domain identities to be created
variable "identities" {
  description = "Map of Domains to configuration"
  type        = map(any)
  default = {
    versent = {
      domain = "prod.versentpoc.com"
    },
    stax = {
      domain = "staxprod.versentpoc.com"
    }
  }
}

# The IAM SMTP user to be created
variable "smtpuser" {
  description = "The name of the IAM user for SMTP"
  type        = string
  default     = "workday-smtp-user"
}

# The AWS profile to use
variable "profile" {
  type    = string
  default = "stax-stax-au1-versent-innovation2"
}