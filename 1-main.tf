provider "azurerm" {}

resource "azurerm_resource_group" "fnrg" {
  name     = "function-rg"
  location = "${var.location}"
}

resource "azurerm_storage_account" "fnsa" {
  name                     = "releasrfnsa"
  resource_group_name      = "${azurerm_resource_group.fnrg.name}"
  location                 = "${var.location}"
  account_tier             = "standard"
  account_replication_type = "lrs"
}

resource "azurerm_app_service_plan" "fnasp" {
  name                = "releasr-fn-asp"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  location            = "${var.location}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "fnapp" {
  name                      = "releasr-fn"
  resource_group_name       = "${azurerm_resource_group.fnrg.name}"
  location                  = "${var.location}"
  app_service_plan_id       = "${azurerm_app_service_plan.fnasp.id}"
  storage_connection_string = "${azurerm_storage_account.fnsa.primary_connection_string}"
  version                   = "~2"
}

resource "azurerm_application_insights" "fnai" {
  name                = "releasrfn-ai"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  location            = "eastus"
  application_type    = "web"
}
