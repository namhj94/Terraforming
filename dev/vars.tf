# main, network variables
variable "location" {
    default = "koreacentral"
}
variable "resourcegroup" {
    default = "TF-dev"
}
variable "prefix" {
    default = "dev"
    description = "environment name"
}
variable "src_ip" {
    default = ""
}
#Compute
variable "admin_username" {
    default = ""
}
variable "admin_password" {
    default = ""
}