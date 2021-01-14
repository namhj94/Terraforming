terraform {
  required_providers{
      azurerm = {
          version = "2.41.0"
      }
      random = {
          version = "3.0.0"
      }
  }
}

provider "azurerm" {
  version = ">= 2.41.0"
  features {}
}
provider "random" {
  
}