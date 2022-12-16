variable "monitor_rg" {
  description = "Resource group for the monitor"
  type        = string
  default     = "rg-bhs-monitor-lt-uks-001"
}

variable "vm_rg" {
  description = "Virtual machine resource group"
  type = string
  default = "rg-bhs-ag1-lt1-lt-uks-001"
}
variable "serv_vm_name" {
  description = "The target serv machine name"
  type        = string
  default     = "vmss-ag1-lt1-serv-lt-uks-001" 
}

variable "spr_vm_name" {
  description = "The target spr machine name"
  type        = string
  default     = "vmss-ag1-lt1-spr-lt-uks-001" 
}

variable "web_vm_name" {
  description = "The target web machine name"
  type        = string
  default     = "vmss-ag1-lt1-web-lt-uks-001" 
}