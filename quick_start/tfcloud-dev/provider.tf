terraform {

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.60"
    }
  }

  backend "remote" {
    organization = "hyukjun-org"

    workspaces {
      name = "dev"
    }
  }
}

provider "azurerm" {
  features {}
}
