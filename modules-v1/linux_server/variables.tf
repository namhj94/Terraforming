variable "resource_group_name" {
  description = "rg name"
}
variable "location" {
  description = "location"
}
variable "hostname" {
}
variable "size" {
  description = "vm size"
}
variable "admin_username" {
  description = "admin user name"
}
variable "admin_password" {
  description = "admin user password"
}
variable "os_disk_sku" {
  description = "os disk sku"
}
variable "publisher" {
  description = "image publisher"
}
variable "offer" {
  description = "image offer"
}
variable "sku" {
  description = "image distro"
}
variable "tag" {
  description = "image version"
}
variable "subnet_id" {
  description = "subnet id"
}
variable "nic_name" {
  description = "nic name"
}

