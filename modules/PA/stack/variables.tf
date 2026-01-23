variable "palo" {
    type = object({
        mgmt = object({
            ip = string
            username = string
            password = string
        })

        network = object({
            
        })
    })

}