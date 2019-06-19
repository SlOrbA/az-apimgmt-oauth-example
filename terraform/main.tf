# Create a resource group for the API Management
resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "westeurope"
}

resource "random_string" "example" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_api_management" "example" {
  name                = "example-${random_string.example.result}"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  publisher_name      = "Example Componay"
  publisher_email     = "example@company.com"

  sku {
    name     = "Developer"
    capacity = 1
  }
}

resource "azurerm_api_management_api" "echo" {
  name                = "echo-api"
  resource_group_name = "${azurerm_resource_group.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  revision            = "1"
  display_name        = "Echo API"
  path                = "echo"
  protocols           = ["https"]

  import {
    content_format = "swagger-link-json"
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }
}

resource "azurerm_api_management_api_operation" "example" {
  operation_id        = "echo"
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management_api.example.api_management_name}"
  resource_group_name = "${azurerm_resource_group_name.example.name}"
  display_name        = "Echo Operation"
  method              = "GET"
  url_template        = "/echo"
  description         = "Echo service for only authenticated users"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_product" "example" {
  product_id          = "example-product"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_api_management.example.resource_group_name}"
  subscription_required = true
  approval_required     = true
  published             = true
}

resource "azurerm_api_management_product_api" "example" {
  api_name            = "${azurerm_api_management_api.echo.name}"
  product_id          = "${azurerm_api_management_product.example.product_id}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
}

resource "azurerm_api_management_user" "example" {
  user_id               = "example-${random_string.example.result}"
  api_management_name   = "${azurerm_api_management.example.name}"
  resource_group_name   = "${azurerm_resource_group.example.name}"
  first_name            = "Example"
  last_name             = "User"
  email                 = "user@example.com"
  state                 = "active"
}

resource "azurerm_api_management_openid_connect_provider" "example" {
  name                = "example-provider"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  client_id           = "00001111-2222-3333-4444-555566667777"
  display_name        = "Example Provider"
  metadata_endpoint   = "https://example.com/example"
}
