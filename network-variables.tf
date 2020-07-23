variable "network-vnet-cidr" {
    type        = string
    description = "The CIDR of the network VNET"
    default     = "10.16.0.0/22"
}

variable "network-subnet-cidr" {
    type        = list
    description = "The CIDR for the network subnet"
    default     = ["10.16.1.0/24"]
}