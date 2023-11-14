variable "imagebuild" {
  type = string
  description = "the latest image build version"
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

### SDGD Front (docker)
resource "azurerm_linux_web_app" "web-front1" {
  https_only          = true
  location            = "eastus"
  name                = "sdgd-front-east"
  resource_group_name = "SDGD-group"
  service_plan_id     = serviceplan1.id
  tags = {
    Region1 = "Api"
  }
  site_config {
    application_stack {
      docker_image_name = "vianrove/sdgd-front:${var.imagebuild}"
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
}

resource "azurerm_linux_web_app" "web-front2" {
  https_only          = true
  location            = "westus"
  name                = "sdgd-front-west"
  resource_group_name = "SDGD-group"
  service_plan_id     = serviceplan2.id
  tags = {
    Region1 = "Api"
  }
  site_config {
    application_stack {
      docker_image_name = "vianrove/sdgd-front:${var.imagebuild}"
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
}
