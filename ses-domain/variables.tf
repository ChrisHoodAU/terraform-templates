variable "identities" {
  description = "Map of Domains to configuration"
  type        = map(any)
  default = {
    versent = {
      domain      = "test.versentpoc.com"
    },
    stax = {
      domain      = "staxtest.versentpoc.com"
    }
  }
}

variable "smtpuser" {
  description = "The name of the IAM user for SMTP"
  type        = string
  default     = "workday-smtp-user"
}

variable "profile" {
  type=string
}