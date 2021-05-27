# Azure Infra Modules
## 1. Provision Single VM
### Modules
- linux_server
    - required field
    - Optional field
- network
    - required field
    - Optional field
- nsg
    - required field
    - Optional field
- public ip
    - required field
    - Optional field
### Sample Code to Example
[Example Code](examples)
## Usage
### Create terraform.tfvars
#### Input variables
```hcl
# rg
resource_group_name = "TF-Module"
location            = "koreacentral"

# network
vnet_name             = "vnet01"
address_space         = "10.0.0.0/16"
subnet_name           = "subnet01"
subnet_address_prefix = "10.0.0.0/24"

# nsg
nsg_name                   = "nsg01"
nsg_rule_name              = "ssh"
nsg_priority               = "100"
nsg_destination_port_range = "22"

# vm
hostname       = "testvm01"
size           = "Standard_F2"
admin_username = "USERNAME"
admin_password = "PASSWORD"
os_disk_sku    = "Standard_LRS"
publisher      = "Canonical"
offer          = "UbuntuServer"
sku            = "18.04-LTS"
tag            = "latest"
nic_name       = "linux-server-01-nic"

# pip
pip_name          = "TF-VM-01-pip"
allocation_method = "Static"
```