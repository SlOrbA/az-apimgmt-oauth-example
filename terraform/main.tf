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

resource "azurerm_api_management_api" "example" {
  name                = "example-api"
  resource_group_name = "${azurerm_resource_group.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  revision            = "1"
  display_name        = "Example (Echo) API"
  path                = "example"
  protocols           = ["https"]
  service_url         = "http://echoapi.cloudapp.net/api"
}

resource "azurerm_api_management_api_policy" "example" {
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  xml_content         = <<XML
  <policies>
    <inbound>
      <base />
    </inbound>
    <backend>
      <base />
    </backend>
    <outbound>
      <base />
    </outbound>
    <on-error>
      <base />
    </on-error>
  </policies>
  XML
}

resource "azurerm_api_management_product" "example" {
  product_id            = "example-product"
  display_name          = "example"
  api_management_name   = "${azurerm_api_management.example.name}"
  resource_group_name   = "${azurerm_resource_group.example.name}"
  subscription_required = true
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_product_api" "example" {
  api_name            = "${azurerm_api_management_api.example.name}"
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
  client_secret       = "aaaabbbb-cccc-dddd-eeee-ffffgggghhhh"
  display_name        = "Example Provider"
  metadata_endpoint   = "https://example.com/example"
}

resource "azurerm_api_management_api_operation" "list" {
  operation_id        = "list"
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  display_name        = "Echo Operation"
  method              = "GET"
  url_template        = "/resource"
  description         = "Echo service for only authenticated users"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "retrieve" {
  operation_id        = "retrieve"
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  display_name        = "Echo Operation"
  method              = "GET"
  url_template        = "/resource/{id}"
  description         = "Echo service for only authenticated users"

  response {
    status_code = 200
  }

  template_parameter {
    description = "resource id" 
    name        = "id"
    required    = true
    type        = "string"
    values      = []
  }
}


resource "azurerm_api_management_api_operation" "modify" {
  operation_id        = "modify"
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  display_name        = "Echo Operation"
  method              = "PUT"
  url_template        = "/resource"
  description         = "Echo service for only authenticated users"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "create" {
  operation_id        = "create"
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  display_name        = "Echo Operation"
  method              = "POST"
  url_template        = "/resource"
  description         = "Echo service for only authenticated users"

  response {
    status_code = 200
  }
}
resource "azurerm_api_management_api_operation_policy" "create" {
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  operation_id        = "${azurerm_api_management_api_operation.create.operation_id}"
  xml_content         = <<XML
  <policies>
    <inbound>
      <base />
      <json-to-xml apply="always" consider-accept-header="false" />
    </inbound>
  </policies>
  XML 
}



resource "azurerm_api_management_api_operation" "remove"{
  operation_id        = "remove"
  api_name            = "${azurerm_api_management_api.example.name}"
  api_management_name = "${azurerm_api_management.example.name}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  display_name        = "Echo Operation"
  method              = "DELETE"
  url_template        = "/resource"
  description         = "Echo service for only authenticated users"

  response {
    status_code = 200
  }

}

