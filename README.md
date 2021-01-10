# Azure in Terraform
## Usage
1. git clone this repo
2. az login
3. terraform init
## Provider
### terraform block
테라폼과 프로바이더의 버전을 따로 관리할 수 있음
- required_version: 특정 테라폼 버전 고정
- required_providers: 특정 프로바이더의 버전 고정

## data block
provider의 리소스 상태를 불러오기 위한 블럭

## Module
재사용성을 높이기 위해 module을 사용한다. dev,stage,production 환경을 나눌 경우 각 환경에서 리소스를 만들기위해 코드를 복붙할 필요 없이 모듈을 사용해 재사용성을 높일 수 있다.
### Directory 구조
```
module
 ├── main.tf
 ├── outputs.tf
 └── variables.tf
main.tf -> main.tf에서 module을 사용해서 넣은 값 들은 모듈 디렉토리 밑에 variables.tf로 들어가서 모듈 밑의 main.tf로 맵핑됨, 혹은 module 밑에 variables.tf에 값을 넣고 외부 main.tf에서 필요한 값만 바꿔서 모듈을 재사용할 수 있다.
```
### modules.json
모듈 설정 확인 가능

## AKS-Terraform Configuration
### Network Plugin
- Azure CNI depends on Vnet's Subnet
### default_node_pool
- Azure CNI를 사용하려면 디폴트 노드 풀에 subnet id 를 넣어줘야 하므로 vnet과 subnet이 우선적으로 생성 되어야 함

