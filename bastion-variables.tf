# azure bastion region
variable "bastion_location" {
    type        = string
    description = "Azure region where the bastion resources will be created"
    default     = "north europe"
}

variable "batstion_vnet_cidr" {
    type        = string
    description = "The CIDR of the network VNET"
    default     = "10.0.4.0/22"
}

variable "batstion_subnet_cidr" {
    type        = string
    description = "The CIDR for the network subnet"
    default     = "10.0.4.0/24"
}