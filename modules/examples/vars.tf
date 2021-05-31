variable "resource_group_name" {
  default = "TF-Module"
}
variable "location" {
  default = "koreacentral"
}

# network
variable "vnet_name" {
}
variable "address_space" {
  type = list
}
variable "subnet_name" {
}
variable "subnet_address_prefix" {
  type = list
}

# vm
variable "hostname" {
}
variable "size" {
}
variable "admin_username" {
}
variable "admin_password" {
}

variable "os_disk_sku" {
}
variable "publisher" {
}
variable "offer" {
}
variable "sku" {
}
variable "tag" {
}
variable "nic_name" {
}

#nsg
variable "nsg_name" {
}
variable "nsg_rule_name" {
}
variable "nsg_priority" {
}
variable "nsg_destination_port_range" {
}

# public ip
variable "pip_name" {
}
variable "allocation_method" {
  default = "Dynamic"
}