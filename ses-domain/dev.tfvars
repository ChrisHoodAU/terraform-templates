variable "identities" {
    description = "Map of Domains to configuration"
    type = Map
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