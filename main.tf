resource "azurerm_resource_group" "sdgd-rg" {
  location = "eastus"
  name     = "SDGD-group"
}

### Mongo database
resource "azurerm_cosmosdb_account" "mongodb" {
  enable_free_tier    = true
  kind                = "MongoDB"
  location            = "westus"
  name                = "sdgd-mongodb"
  offer_type          = "Standard"
  resource_group_name = "SDGD-group"
  tags = {
    defaultExperience       = "Azure Cosmos DB for MongoDB API"
    hidden-cosmos-mmspecial = ""
  }
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    failover_priority = 0
    location          = "westus"
  }
  depends_on = [
    azurerm_resource_group.sdgd-rg,
  ]
}

output "mongodb" {
  value = azurerm_cosmosdb_account.mongodb
}

### Storage account
resource "azurerm_storage_account" "storage-account" {
  account_replication_type         = "RAGRS"
  account_tier                     = "Standard"
  cross_tenant_replication_enabled = false
  location                         = "eastus"
  name                             = "sdgd"
  resource_group_name              = "SDGD-group"
  depends_on = [
    azurerm_resource_group.sdgd-rg,
  ]
}

### Service plan EAST-US
resource "azurerm_service_plan" "service-plan1" {
  location            = "eastus"
  name                = "AppServicePlan-Region1"
  os_type             = "Linux"
  resource_group_name = "SDGD-group"
  sku_name            = "B1"
  tags = {
    Region1 = "AppServicePlan"
  }
  depends_on = [
    azurerm_resource_group.sdgd-rg,
  ]
}

output "serviceplan1" {
  value = azurerm_service_plan.service-plan1
}

### Service plan WEST-US
resource "azurerm_service_plan" "service-plan2" {
  location            = "westus"
  name                = "AppServicePlan-Region2"
  os_type             = "Linux"
  resource_group_name = "SDGD-group"
  sku_name            = "B1"
  tags = {
    Region2 = "AppServicePlan"
  }
  depends_on = [
    azurerm_resource_group.sdgd-rg,
  ]
}

output "serviceplan2" {
  value = azurerm_service_plan.service-plan2
}

module "app_service_clientes" {
  source              = "./modules/app_services/clientes"
}

module "app_service_documentos" {
  source              = "./modules/app_services/documentos"
}

module "app_service_carrito" {
  source              = "./modules/app_services/carrito"
}

module "app_service_front" {
  source              = "./modules/app_services/front"
}

module "app_service_login" {
  source              = "./modules/app_services/login"
}

module "app_service_pasarela" {
  source              = "./modules/app_services/pasarela"
}

module "frontdoor" {
  source              = "./modules/frontdoor"
}