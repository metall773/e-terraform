variable "network-vnet-cidr" {
    type        = string
    description = "The CIDR of the network VNET"
    default     = "10.0.0.0/16"
}

variable "network-subnet-cidr" {
    type        = list
    description = "The CIDR for the network subnet"
    default     = ["10.0.1.0/24"]
}

variable "batstion_subnet_cidr" {
    type        = string
    description = "The CIDR for the network subnet"
    default     = "10.0.2.0/24"
}