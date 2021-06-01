# AKS-Terraform Configuration
### Network Plugin
- Azure CNI depends on Vnet's Subnet
### default_node_pool
- Azure CNI를 사용하려면 디폴트 노드 풀에 subnet id 를 넣어줘야 하므로 vnet과 subnet이 우선적으로 생성 되어야 함
