# company name 
variable "company" {
    type        = string
    description = "The company name used to build resources"
    default     = "e-tiketka"
}

# application name 
variable "app_name" {
    type        = string
    description = "The application name used to build resources"
    default     = "e-tiketka-app"
}

# environment
variable "environment" {
    type        = string
    description = "The environment to be built"
    default     = "dev"
}

# azure vm region
variable "location" {
    type        = string
    description = "Azure region where the resources will be created"
    default     = "north europe" # "germanywestcentral"
}

#Azure authentication variables
variable "ARM_SUBSCRIPTION_ID" {
  type = string
  description = "Azure Subscription ID"
}

variable "ARM_CLIENT_ID" {
  type = string
  description = "Azure Client ID"
}

variable "ARM_CLIENT_SECRET" {
  type = string
  description = "Azure Client Secret"
}

variable "ARM_TENANT_ID" {
  type = string
  description = "Azure Tenant ID"
}