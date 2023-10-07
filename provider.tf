provider "azurerm" {
  skip_provider_registration = "true"
  features {}
  
  tenant_id       = "your-tenant-id-here"
  subscription_id = "your-subscription-id-here"

}