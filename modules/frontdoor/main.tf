### Front door profile set-up
resource "azurerm_cdn_frontdoor_profile" "fdprofile" {
  name                     = "FD-profile"
  resource_group_name      = "SDGD-group"
  response_timeout_seconds = 60
  sku_name                 = "Standard_AzureFrontDoor"
  tags = {
    Global = "FDProfile"
  }
  depends_on = [
    azurerm_resource_group.sdgd-rg,
  ]
}

output "frontdoorprofile" {
  value = azurerm_cdn_frontdoor_profile.fdprofile
}

### Front door endpoints
resource "azurerm_cdn_frontdoor_endpoint" "fdprofile-carrito" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                     = "sdgd-carrito"
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
    azurerm_linux_web_app.web-api-carrito1
  ]
}
resource "azurerm_cdn_frontdoor_endpoint" "fdprofile-clientes" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                     = "sdgd-clientes"
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
    azurerm_linux_web_app.web-api-clientes1
  ]
}
resource "azurerm_cdn_frontdoor_endpoint" "fdprofile-documentos" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                     = "sdgd-documentos"
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
    azurerm_linux_web_app.web-api-documentos1
  ]
}
resource "azurerm_cdn_frontdoor_endpoint" "fdprofile-login" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                     = "sdgd-login"
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
    azurerm_linux_web_app.web-api-login1
  ]
}
resource "azurerm_cdn_frontdoor_endpoint" "fdprofile-pasarela" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                     = "sdgd-pasarela"
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
    azurerm_linux_web_app.web-api-pasarela1
  ]
}

output "pasarelaendpoint" {
  value = azurerm_cdn_frontdoor_endpoint.fdprofile-pasarela
}

resource "azurerm_cdn_frontdoor_endpoint" "fdprofile-front" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                     = "sdgd-front"
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
    azurerm_linux_web_app.web-front1
  ]
}

resource "azurerm_cdn_frontdoor_route" "res-3" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdprofile-carrito.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorig-group-carrito.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorig-carrito1.id, azurerm_cdn_frontdoor_origin.fdorig-carrito2.id]
  name                          = "api-carrito"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.fdprofile-carrito,
    azurerm_cdn_frontdoor_origin_group.fdorig-group-carrito,
  ]
}

resource "azurerm_cdn_frontdoor_route" "res-5" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdprofile-clientes.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorig-group-clientes.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorig-clientes1.id, azurerm_cdn_frontdoor_origin.fdorig-clientes2.id]
  name                          = "api-clientes"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.fdprofile-clientes,
    azurerm_cdn_frontdoor_origin_group.fdorig-group-clientes,
  ]
}

resource "azurerm_cdn_frontdoor_route" "res-7" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdprofile-documentos.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorig-group-documentos.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorig-documentos1.id, azurerm_cdn_frontdoor_origin.fdorig-documentos2.id]
  name                          = "api-documentos"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.fdprofile-documentos,
    azurerm_cdn_frontdoor_origin_group.fdorig-group-documentos,
  ]
}

resource "azurerm_cdn_frontdoor_route" "fdroute-login" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdprofile-login.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorig-group-login.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorig-login1.id, azurerm_cdn_frontdoor_origin.fdorig-login1.id]
  name                          = "api-login"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.fdprofile-login,
    azurerm_cdn_frontdoor_origin_group.fdorig-group-login,
  ]
}

resource "azurerm_cdn_frontdoor_route" "fdroute-pasarela" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdprofile-pasarela.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorig-pasarela1.id, azurerm_cdn_frontdoor_origin.fdorig-pasarela2.id]
  name                          = "api-pasarela"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.fdprofile-pasarela,
    azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela,
  ]
}

resource "azurerm_cdn_frontdoor_route" "fdroute-front" {
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdprofile-front.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorig-pasarela1.id, azurerm_cdn_frontdoor_origin.fdorig-pasarela2.id]
  name                          = "sdgd-front"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.fdprofile-front,
    azurerm_cdn_frontdoor_origin_group.fdorig-group-front,
  ]
}

resource "azurerm_cdn_frontdoor_origin_group" "fdorig-group-carrito" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                                                      = "sdgd-carrito"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  health_probe {
    interval_in_seconds = 120
    protocol            = "Http"
    request_type        = "GET"
  }
  load_balancing {
  }
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-carrito1" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-carrito.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-carrito1.default_hostname
  name                           = "api-region1"
  origin_host_header             = azurerm_linux_web_app.web-api-carrito1.default_hostname
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-carrito,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-carrito2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-carrito.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-carrito2.default_hostname
  name                           = "api-region2"
  origin_host_header             = azurerm_linux_web_app.web-api-carrito2.default_hostname
  priority                       = 2
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-carrito,
  ]
}
resource "azurerm_cdn_frontdoor_origin_group" "fdorig-group-clientes" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                                                      = "sdgd-clientes"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  health_probe {
    interval_in_seconds = 120
    protocol            = "Http"
    request_type        = "GET"
  }
  load_balancing {
  }
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-clientes1" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-clientes.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-clientes1.default_hostname
  name                           = "api-region1"
  origin_host_header             = azurerm_linux_web_app.web-api-clientes1.default_hostname
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-clientes,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-clientes2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-clientes.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-clientes2.default_hostname
  name                           = "api-region2"
  origin_host_header             = azurerm_linux_web_app.web-api-clientes2.default_hostname
  priority                       = 2
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-clientes,
  ]
}
resource "azurerm_cdn_frontdoor_origin_group" "fdorig-group-documentos" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                                                      = "sdgd-documentos"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  health_probe {
    interval_in_seconds = 120
    protocol            = "Http"
    request_type        = "GET"
  }
  load_balancing {
  }
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-documentos1" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-documentos.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-documentos1.default_hostname
  name                           = "api-region1"
  origin_host_header             = azurerm_linux_web_app.web-api-documentos1.default_hostname
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-documentos,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-documentos2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-documentos.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-documentos2.default_hostname
  name                           = "api-region2"
  origin_host_header             = azurerm_linux_web_app.web-api-documentos2.default_hostname
  priority                       = 2
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-documentos,
  ]
}
resource "azurerm_cdn_frontdoor_origin_group" "fdorig-group-login" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                                                      = "sdgd-login"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  health_probe {
    interval_in_seconds = 120
    protocol            = "Http"
    request_type        = "GET"
  }
  load_balancing {
  }
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-login1" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-login.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-login1.default_hostname
  name                           = "api-region1"
  origin_host_header             = azurerm_linux_web_app.web-api-login1.default_hostname
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-login,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-login2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-login.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-login2.default_hostname
  name                           = "api-region2"
  origin_host_header             = azurerm_linux_web_app.web-api-login2.default_hostname
  priority                       = 2
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-login,
  ]
}
resource "azurerm_cdn_frontdoor_origin_group" "fdorig-group-pasarela" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                                                      = "sdgd-pasarela"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  health_probe {
    interval_in_seconds = 120
    protocol            = "Http"
    request_type        = "GET"
  }
  load_balancing {
  }
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-pasarela1" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-pasarela1.default_hostname
  name                           = "api-region1"
  origin_host_header             = azurerm_linux_web_app.web-api-pasarela1.default_hostname
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela,
  ]
}
resource "azurerm_cdn_frontdoor_origin" "fdorig-pasarela2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-api-pasarela2.default_hostname
  name                           = "api-region2"
  origin_host_header             = azurerm_linux_web_app.web-api-pasarela2.default_hostname
  priority                       = 2
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela,
  ]
}

resource "azurerm_cdn_frontdoor_origin_group" "fdorig-group-front" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.fdprofile.id
  name                                                      = "sdgd-front"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  health_probe {
    interval_in_seconds = 120
    protocol            = "Http"
    request_type        = "GET"
  }
  load_balancing {
  }
  depends_on = [
    azurerm_cdn_frontdoor_profile.fdprofile,
  ]
}

resource "azurerm_cdn_frontdoor_origin" "fdorig-front1" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-front.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-front1.default_hostname
  name                           = "front-region1"
  origin_host_header             = azurerm_linux_web_app.web-front1.default_hostname
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela,
  ]
}

resource "azurerm_cdn_frontdoor_origin" "fdorig-front2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fdorig-group-front.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = azurerm_linux_web_app.web-front1.default_hostname
  name                           = "front-region2"
  origin_host_header             = azurerm_linux_web_app.web-front1.default_hostname
  priority                       = 2
  weight                         = 1000
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fdorig-group-pasarela,
  ]
}