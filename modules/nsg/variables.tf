# Required
variable "resource_group_name" {
    type = string
    description = "Resource Group Name"
}
variable "location" {
    type = string
    description = "location"
}
variable "nsg_name" {
    type = string
    description = "NSG Name"
}
variable "rule_name" {
    type = string
    description = "NSG Rule Name"
}
variable "priority" {
    type = number
    description = "NSG Rule Priority"
}
variable "destination_port_range" {
    type = string
    description = "destination port range"
}
variable "subnet_id" {
    type = string
    description = "Subnet id from network module"
}