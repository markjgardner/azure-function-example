terraform {
  backend "azurerm" {
    container_name = "terraform"
    key            = "function"
  }
}

provider "azurerm" {}

resource "azurerm_resource_group" "fnrg" {
  name     = "function-rg"
  location = "${var.location}"
}

resource "azurerm_storage_account" "fnsa" {
  name                      = "releasrfnsa"
  resource_group_name       = "${azurerm_resource_group.fnrg.name}"
  location                  = "${var.location}"
  account_tier              = "standard"
  account_replication_type  = "lrs"
  enable_https_traffic_only = "true"
}

resource "azurerm_storage_queue" "fnsaqueue" {
  name                 = "functionqueue"
  resource_group_name  = "${azurerm_resource_group.fnrg.name}"
  storage_account_name = "${azurerm_storage_account.fnsa.name}"
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

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.fnai.instrumentation_key}"
    AzureWebJobsServiceBus         = "${azurerm_servicebus_namespace_authorization_rule.fnsbnpolicy.primary_connection_string}"
  }

  connection_string {
    name  = "AzureWebJobsServiceBus"
    type  = "ServiceBus"
    value = "${azurerm_servicebus_namespace_authorization_rule.fnsbnpolicy.primary_connection_string}"
  }
}

resource "azurerm_application_insights" "fnai" {
  name                = "releasrfn-ai"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  location            = "eastus"
  application_type    = "web"
}

resource "azurerm_servicebus_namespace" "fnsbn" {
  name                = "releasr-sn"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  location            = "${var.location}"
  sku                 = "standard"
}

resource "azurerm_servicebus_topic" "fntopic" {
  name                = "functiontop"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  namespace_name      = "${azurerm_servicebus_namespace.fnsbn.name}"
  enable_partitioning = true
}

resource "azurerm_servicebus_namespace_authorization_rule" "fnsbnpolicy" {
  name                = "functionpolicy"
  namespace_name      = "${azurerm_servicebus_namespace.fnsbn.name}"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_servicebus_subscription" "fnsub" {
  name                = "functionsub"
  resource_group_name = "${azurerm_resource_group.fnrg.name}"
  namespace_name      = "${azurerm_servicebus_namespace.fnsbn.name}"
  topic_name          = "${azurerm_servicebus_topic.fntopic.name}"
  max_delivery_count  = 1
}
