# Terraform template that violates CKV_AZURE_59 and CKV2_AZURE_31

# Violating CKV_AZURE_59 by allowing public access to storage account
resource "azurerm_storage_account" "bad_example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # Allowing public access
  allow_blob_public_access = true
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

# Violating CKV2_AZURE_31 by not associating a network security group with subnet
resource "azurerm_virtual_network" "bad_example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "bad_example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.bad_example.name
  address_prefixes     = ["10.0.1.0/24"]

  # No network security group associated
}
