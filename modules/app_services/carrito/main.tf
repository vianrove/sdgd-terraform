variable "imagebuild" {
  type = string
  description = "the latest image build version"
}

variable "mongodb" {
  description = "Cosmosdb account"
  type = any
}

variable "serviceplan1" {
  description = "Service plan EAST"
  type = any

}
variable "serviceplan2" {
  description = "Service plan WEST"
  type = any
}

variable "frontdoorprofile" {
  description = "Front door profile"
  type = any
}

### Carrito api (docker)
resource "azurerm_linux_web_app" "web-api-carrito1" {
  app_settings = {
    MONGODB_URI                         = mongodb.connection_strings[0]
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    database                            = "gestiondocumental"
    db_port                             = "3306"
    host                                = "mysql-instance-sdgd.mysql.database.azure.com"
    password                            = "sdgd8@23"
    user                                = "admin378"
  }
  https_only          = true
  location            = "eastus"
  name                = "sdgd-shoppingcart-east"
  resource_group_name = "SDGD-group"
  service_plan_id     = serviceplan1.id
  tags = {
    Region1 = "Api"
  }
  site_config {
    application_stack {
      docker_image_name = "jhonpilot/servicecarrito:${var.imagebuild}"
      docker_registry_url = "https://index.docker.io"
    }
    always_on  = false
    ftps_state = "FtpsOnly"
    ip_restriction {
      headers = [{
        x_azure_fdid      = [frontdoorprofile.resource_guid]
        x_fd_health_probe = []
        x_forwarded_for   = []
        x_forwarded_host  = []
      }]
      priority    = 100
      service_tag = "AzureFrontDoor.Backend"
    }
  }
  depends_on = [
    serviceplan1,
  ]
}
### Carrito api (docker)
resource "azurerm_linux_web_app" "web-api-carrito2" {
  app_settings = {
    MONGODB_URI                         = mongodb.connection_strings[0]
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    database                            = "gestiondocumental"
    db_port                             = "3306"
    host                                = "mysql-instance-sdgd.mysql.database.azure.com"
    password                            = "sdgd8@23"
    user                                = "admin378"
  }
  https_only          = true
  location            = "westus"
  name                = "sdgd-shoppingcart-west"
  resource_group_name = "SDGD-group"
  service_plan_id     = serviceplan2.id
  tags = {
    Region2 = "Api"
  }
  site_config {
    application_stack {
      docker_image_name = "jhonpilot/servicecarrito:${var.imagebuild}"
      docker_registry_url = "https://index.docker.io"
    }
    always_on  = false
    ftps_state = "FtpsOnly"
    ip_restriction {
      headers = [{
        x_azure_fdid      = [frontdoorprofile.resource_guid]
        x_fd_health_probe = []
        x_forwarded_for   = []
        x_forwarded_host  = []
      }]
      priority    = 100
      service_tag = "AzureFrontDoor.Backend"
    }
  }
  depends_on = [
    serviceplan2,
  ]
}
