variable "identities" {
    description = "Map of Domains to configuration"
    type = map
    default = {
        versent = {
            domain = "test.versentpoc.com"
            environment = "dev"
        },
        stax = {
            domain = "staxtest.versentpoc.com"
            environment = "dev"
        }
    }
}

variable "smtpuser" {
    description = "The name of the IAM user for SMTP"
    type = string
    default = "workday-smtp-user"
}