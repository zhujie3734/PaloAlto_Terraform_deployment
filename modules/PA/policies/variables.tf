variable "security_rules" {
    description = "Security policy rules to create"
    type = list(object({
        name = string
        from = string
        to = string
        src = list(string)
        dst = list(string)
        app = list(string)
        svc = list(string)
        action = string # allow | deny
        log = optional(bool, true)
    }))
    default = []
}