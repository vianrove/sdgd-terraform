resource "azurerm_resource_group" "sdgd-rg" {
  location = "eastus"
  name     = "SDGD-group"
}

output "resourcegroupname" {
  value = azurerm_resource_group.sdgd-rg.name
}