variable "resourcegroup" {
    type = string
    default = "TF-rg"
}
variable "location" {
    type = string
    default = "koreacentral"
}
variable "prefix"{
    default = "hol-1"
}
variable "admin_username" {
    default = "azureuser"
    description = "vm admin username"
}
variable "admin_password" {
    default = "dkagh1.dkagh1."
    description = "vm admin password"
}