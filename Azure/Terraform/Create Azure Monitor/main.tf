provider "azurerm" {
  features {}
}

# Create a resource group if it doesn't exist.
resource "azurerm_resource_group" "monitor_resource_group" {
    name     = var.monitor_rg
    location = "uksouth"
}

resource "azurerm_log_analytics_workspace" "analytics_workspace" {
  name                = "lt-loganalytics-workspace"
  location            = azurerm_resource_group.monitor_resource_group.location
  resource_group_name = azurerm_resource_group.monitor_resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "analytics_solution" {
  solution_name         = "WindowsEventForwarding"
  location              = azurerm_resource_group.monitor_resource_group.location
  resource_group_name   = azurerm_resource_group.monitor_resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.analytics_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.analytics_workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/WindowsEventForwarding"
  }
}

## Add extensions to all vms
resource "azurerm_virtual_machine_extension" "ServAzureMonitorWindowsAgent" {        
      name                 = "ServAzureMonitorWindowsAgent"
      publisher            = "Microsoft.Azure.Monitor"
      type                 = "AzureMonitorWindowsAgent"
      type_handler_version = "1.10"
    
      virtual_machine_id = var.serv_vm
}

##resource "azurerm_virtual_machine_extension" "SprAzureMonitorWindowsAgent" {        
##      name                 = "SprAzureMonitorWindowsAgent"
##      publisher            = "Microsoft.Azure.Monitor"
##      type                 = "AzureMonitorWindowsAgent"
##      type_handler_version = "1.10"
##    
##      virtual_machine_id = var.spr_vm
##}
##
##resource "azurerm_virtual_machine_extension" "WebAzureMonitorWindowsAgent" {        
##      name                 = "WebAzureMonitorWindowsAgent"
##      publisher            = "Microsoft.Azure.Monitor"
##      type                 = "AzureMonitorWindowsAgent"
##      type_handler_version = "1.10"
##    
##      virtual_machine_id = var.web_vm
##}

##resource "azurerm_virtual_machine_extension" "MicrosoftMonitoringAgent" {        
##      name                 = "MicrosoftMonitoringAgent"
##      publisher            = "Microsoft.EnterpriseCloud.Monitoring"
##      type                 = "MicrosoftMonitoringAgent"
##      type_handler_version = "1.0\\"
##    
##      virtual_machine_id = var.target_vm
##}

## Serv Data Collection Rule
resource "azurerm_monitor_data_collection_rule" "lt1-serv_collection_rule" {
  name                = "lt1-serv-collection-services"
  resource_group_name = azurerm_resource_group.monitor_resource_group.name
  location            = azurerm_resource_group.monitor_resource_group.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.analytics_workspace.id
      name                  = "destination-log"
    }

    azure_monitor_metrics {
      name = "destination-metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics"]
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["destination-log"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 10
      counter_specifiers            = ["\\Processor Information(_Total)\\% Processor Time",
                                       "\\Processor Information(_Total)\\% Privileged Time",
                                       "\\Processor Information(_Total)\\% User Time",
                                       "\\Processor Information(_Total)\\Processor Frequency",
                                       "\\Process(_Total)\\Working Set",
                                       "\\Process(_Total)\\Working Set - Private",
                                       "\\Memory\\Available Bytes",
                                       "\\Process(BhServer)\\% Processor Time",
                                       "\\Process(BhServer)\\Working Set",
                                       "\\Process(BhServer)\\Working Set - Private",
                                       "\\Process(BhServer)\\IO Data Operations/sec",
                                       "\\Process(BhWcfHost)\\% Processor Time",
                                       "\\Process(BhWcfHost)\\Working Set",
                                       "\\Process(BhWcfHost)\\Working Set - Private",
                                       "\\Process(BhWcfHost)\\IO Data Operations/sec"
                                        ]
      name                          = "datasource-perfcounter"
    }

  }

  description = "data collection rule for BigHand components"

  depends_on = [
    azurerm_log_analytics_solution.analytics_solution
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "serv_data_collection_association" {
  name                    = "serv_data_collection_association"
  target_resource_id      = var.serv_vm
  data_collection_rule_id = azurerm_monitor_data_collection_rule.lt1-serv_collection_rule.id
  description             = "associate vm to the data collection rule"
}
##
#### Spr Data collection rule
##resource "azurerm_monitor_data_collection_rule" "lt1-spr_collection_rule" {
##  name                = "lt1-spr-collection-services"
##  resource_group_name = azurerm_resource_group.monitor_resource_group.name
##  location            = azurerm_resource_group.monitor_resource_group.location
##
##  destinations {
##    log_analytics {
##      workspace_resource_id = azurerm_log_analytics_workspace.analytics_workspace.id
##      name                  = "destination-log"
##    }
##
##    azure_monitor_metrics {
##      name = "destination-metrics"
##    }
##  }
##
##  data_flow {
##    streams      = ["Microsoft-InsightsMetrics"]
##    destinations = ["destination-metrics"]
##  }
##
##  data_flow {
##    streams      = ["Microsoft-Perf"]
##    destinations = ["destination-log"]
##  }
##
##  data_sources {
##    performance_counter {
##      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
##      sampling_frequency_in_seconds = 10
##      counter_specifiers            = ["\\Processor Information(_Total)\\% Processor Time",
##                                       "\\Processor Information(_Total)\\% Privileged Time",
##                                       "\\Processor Information(_Total)\\% User Time",
##                                       "\\Processor Information(_Total)\\Processor Frequency",
##                                       "\\Process(_Total)\\Working Set",
##                                       "\\Process(_Total)\\Working Set - Private",
##                                       "\\Memory\\Available Bytes",
##                                       "\\Process(ExternalWorkflowServer)\\% Processor Time",
##                                       "\\Process(ExternalWorkflowServer)\\Working Set",
##                                       "\\Process(ExternalWorkflowServer)\\Working Set - Private",
##                                       "\\Process(ExternalWorkflowServer)\\IO Data Operations/sec"
##                                        ]
##      name                          = "datasource-perfcounter"
##    }
##
##  }
##
##  description = "data collection rule for BigHand components"
##
##  depends_on = [
##    azurerm_log_analytics_solution.analytics_solution
##  ]
##}
##
##resource "azurerm_monitor_data_collection_rule_association" "spr_data_collection_association" {
##  name                    = "spr_data_collection_association"
##  target_resource_id      = var.spr_vm
##  data_collection_rule_id = azurerm_monitor_data_collection_rule.lt1-spr_collection_rule.id
##  description             = "associate vm to the data collection rule"
##}
##
#### Web Collection Rules
##resource "azurerm_monitor_data_collection_rule" "lt1-web_collection_rule" {
##  name                = "lt1-web-collection-services"
##  resource_group_name = azurerm_resource_group.monitor_resource_group.name
##  location            = azurerm_resource_group.monitor_resource_group.location
##
##  destinations {
##    log_analytics {
##      workspace_resource_id = azurerm_log_analytics_workspace.analytics_workspace.id
##      name                  = "destination-log"
##    }
##
##    azure_monitor_metrics {
##      name = "destination-metrics"
##    }
##  }
##
##  data_flow {
##    streams      = ["Microsoft-InsightsMetrics"]
##    destinations = ["destination-metrics"]
##  }
##
##  data_flow {
##    streams      = ["Microsoft-Perf"]
##    destinations = ["destination-log"]
##  }
##
##  data_sources {
##    performance_counter {
##      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
##      sampling_frequency_in_seconds = 10
##      counter_specifiers            = ["\\Processor Information(_Total)\\% Processor Time",
##                                       "\\Processor Information(_Total)\\% Privileged Time",
##                                       "\\Processor Information(_Total)\\% User Time",
##                                       "\\Processor Information(_Total)\\Processor Frequency",
##                                       "\\Process(_Total)\\Working Set",
##                                       "\\Process(_Total)\\Working Set - Private",
##                                       "\\Memory\\Available Bytes",
##                                       "\\Process(SecurityBrokerHost)\\% Processor Time",
##                                       "\\Process(SecurityBrokerHost)\\Working Set",
##                                       "\\Process(SecurityBrokerHost)\\Working Set - Private",
##                                       "\\Process(SecurityBrokerHost)\\IO Data Operations/sec"
##                                        ]
##      name                          = "datasource-perfcounter"
##    }
##
##  }
##
##  description = "data collection rule for BigHand components"
##
##  depends_on = [
##    azurerm_log_analytics_solution.analytics_solution
##  ]
##}
##
##resource "azurerm_monitor_data_collection_rule_association" "web_data_collection_association" {
##  name                    = "web_data_collection_association"
##  target_resource_id      = var.web_vm
##  data_collection_rule_id = azurerm_monitor_data_collection_rule.lt1-web_collection_rule.id
##  description             = "associate vm to the data collection rule"
##}
##