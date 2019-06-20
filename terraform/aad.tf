data "azurerm_client_config" "current" {}

resource "azuread_application" "example-api" {
  name = "example-api"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
}

resource "azuread_application" "example-client" {
  name = "example-client"

  required_resource_access {
    resource_app_id = "${azuread_application.example-api.application_id}"
    resource_access {
      id   = "48fd84d4-68a9-4ec7-96a6-2e4d659d3e50"
      type = "Scope"
    }
  }
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

} 

resource "random_string" "example-client" {
 length = 32
}

resource "azuread_application_password" "example-client" {
  application_id = "${azuread_application.example-client.id}"
  value          = "${random_string.example-client.result}"
  end_date       = "2030-01-01T01:02:03Z"
}
