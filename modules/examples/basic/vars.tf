variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = "TF-Module"
}
variable "location" {
  type        = string
  description = "Location"
  default     = "koreacentral"
}

# network
variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
}
variable "address_space" {
  type        = list(any)
  description = "Address Space, list"
}
variable "subnet_name" {
  type        = string
  description = "Subnet Name"
}
variable "subnet_address_prefix" {
  type        = list(any)
  description = "Subnet Address, list"
}

# vm
variable "hostname" {
  type        = string
  description = "Computer Name"
}
variable "size" {
  type        = string
  description = "VM Size"
}
variable "admin_username" {
  type        = string
  description = "User name"
}
variable "admin_password" {
  type        = string
  description = "Password"
}
variable "os_disk_sku" {
  type        = string
  description = "OS Disk sku"
}
variable "publisher" {
  type        = string
  description = "OS Publisher"
}
variable "offer" {
  type        = string
  description = "OS Offer"
}
variable "sku" {
  type        = string
  description = "OS SKU"
}
variable "os_tag" {
  type        = string
  description = "OS Version"
}
variable "nic_name" {
  type        = string
  description = "NIC Name"
}


# public ip
variable "pip_name" {
  type        = string
  description = "Public ip name"
}
variable "allocation_method" {
  type        = string
  description = "Public ip allocation method"
  default     = "Dynamic"
}