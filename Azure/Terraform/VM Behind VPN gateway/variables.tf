# Declare variables that will be used accross the files
variable "resource_group" {
  type = object({
    name = string
    location = string
  })
  description = "Resource group base name."
}