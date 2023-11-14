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

### Pasarela api (docker)
resource "azurerm_linux_web_app" "web-api-pasarela1" {
  app_settings = {
    MONGODB_URI                         = mongodb.connection_strings[0]
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }
  https_only          = true
  location            = "eastus"
  name                = "sdgd-pasarela-east"
  resource_group_name = "SDGD-group"
  service_plan_id     = serviceplan1.id
  tags = {
    Region1 = "Api"
  }
  site_config {
    application_stack {
      docker_image_name = "vianrove/api-pasarela:latest"
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
  sticky_settings {
    app_setting_names = ["MONGODB_URI"]
  }
  depends_on = [
    serviceplan1,
  ]
}
### Pasarela api (docker)
resource "azurerm_linux_web_app" "web-api-pasarela2" {
  app_settings = {
    DOCKER_ENABLE_CI                    = "true"
    MONGODB_URI                         = mongodb.connection_strings[0]
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }
  https_only          = true
  location            = "westus"
  name                = "sdgd-pasarela-west"
  resource_group_name = "SDGD-group"
  service_plan_id     = serviceplan2.id
  tags = {
    Region2 = "Api"
  }
  site_config {
    application_stack {
      docker_image_name = "vianrove/api-pasarela:latest"
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
  sticky_settings {
    app_setting_names = ["MONGODB_URI"]
  }
  depends_on = [
    serviceplan2,
  ]
}
