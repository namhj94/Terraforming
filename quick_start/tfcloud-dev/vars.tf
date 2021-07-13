variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = "TF-Module-Cloud"
}
variable "location" {
  type        = string
  description = "Location"
  default     = "koreacentral"
}

# vm
variable "admin_username" {
  type        = string
  description = "User name"
}
variable "admin_password" {
  type        = string
  description = "Password"
}

# public ip
variable "allocation_method" {
  type        = string
  description = "Public ip allocation method"
  default     = "Dynamic"
}