# Azure Infra Modules
## 1. Provision Single VM
### Modules
- linux_server
    - Required Values
        ```
        resource_group_name 
        location             
        hostname
        size                
        admin_username      
        admin_password       
        os_disk_sku          
        publisher            
        offer                
        sku                  
        os_tag                  
        subnet_id            
        nic_name             
        public_ip_address_id 
        ```
    - Optional Values
        ```
        ip_configuration_name
        private_ip_address_allocation
        os_disk_caching
        ```
- network
    - Required Values
        ```
        resource_group_name  
        location             
        vnet_name            
        address_space        
        subnet_name          
        subnet_address_prefix
        ```
    - Optional Values
- nsg
    - Required Values
        ```
        resource_group_name
        location
        nsg_name
        rule_name
        priority
        destination_port_range
        subnet_id   
        ```
    - Optional Values
- public ip
    - Required Values
        ```
        resource_group_name
        location
        pip_name
        pip_allocation_method
        ```
    - Optional Values
### Sample Code to Example
[Example Code](examples)
## Usage
### 1. Create vars.tf
### 2. Create terraform.tfvars
#### Input variables
```hcl
# rg
resource_group_name = "TF-Module"
location            = "koreacentral"

# network
vnet_name             = "vnet01"
address_space         = ["10.0.0.0/16"]
subnet_name           = "subnet01"
subnet_address_prefix = ["10.0.0.0/24"]

# nsg
nsg_name                   = "nsg01"
nsg_rule_name              = "ssh"
nsg_priority               = "100"
nsg_destination_port_range = "22"

# vm
hostname       = "testvm01"
size           = "Standard_F2"
admin_username = "USER_NAME"
admin_password = "PASSWORD"
os_disk_sku    = "Standard_LRS"
publisher      = "Canonical"
offer          = "UbuntuServer"
sku            = "18.04-LTS"
os_tag         = "latest"
nic_name       = "linux-server-01-nic"

# pip
pip_name          = "TF-VM-01-pip"
allocation_method = "Static"
```