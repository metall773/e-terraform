# azure bastion region
variable "bastion_location" {
    type        = string
    description = "Azure region where the bastion resources will be created"
    default     = "north europe"
}

variable "batstion_subnet_cidr" {
    type        = string
    description = "The CIDR for the network subnet"
    default     = "10.0.4.0/24"
}