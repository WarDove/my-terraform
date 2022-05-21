
variable "ext_port" {
  type = list(number)
}

variable "int_port" {
  type    = number
  default = 1880
  
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

# variable "container_count" {
#   type    = number
#   default = 1
# }

locals {
  container_count = length(var.ext_port)
}