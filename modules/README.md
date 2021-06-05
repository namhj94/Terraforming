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
        rules
        ```
        ```
        rules
        "[name, priority, direction, access, protocol, ,source_address_prefix/es, source_port_range, destination_address_prefix/es, destination_port_range,source_application_security_group_ids]"

        서비스 태그 및 *(Any)는 source_address_prefix/destination_address_prefix 에 선언
        복수 주소는 source_address_prefixes/destination_address_prefixes 에 list로 선언

        *포트가 여러개 일 경우 source_port_range/destination_port_range 에 string 형식으로("3000, 3001") 선언
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

# vm
hostname       = "testvm01"
size           = "Standard_F2"
admin_username = "USERNAME"
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