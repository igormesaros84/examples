variable "monitor_rg" {
  description = "Resource group for the monitor"
  type        = string
  default     = "rg-bhs-monitor-lt-uks-001"
}

variable "serv_vm" {
  description = "The VM that should be monitored"
  type        = string
  default     = "/subscriptions/9e3fdfd9-6c3d-43ed-a62e-867c8231532a/resourceGroups/rg-bhs-ag1-lt1-lt-uks-001/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-ag1-lt1-serv-lt-uks-001/virtualMachines/0" 
}

variable "spr_vm" {
  description = "The VM that should be monitored"
  type        = string
  default     = "/subscriptions/9e3fdfd9-6c3d-43ed-a62e-867c8231532a/resourceGroups/rg-bhs-ag1-lt1-lt-uks-001/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-ag1-lt1-spr-lt-uks-001/virtualMachines/0" 
}

variable "web_vm" {
  description = "The VM that should be monitored"
  type        = string
  default     = "/subscriptions/9e3fdfd9-6c3d-43ed-a62e-867c8231532a/resourceGroups/rg-bhs-ag1-lt1-lt-uks-001/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-ag1-lt1-web-lt-uks-001/virtualMachines/0" 
}