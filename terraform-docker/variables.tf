variable "image" {
  type        = map(any)
  description = "Container Image"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map(any)
  # For dev env
  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "External port for dev env must be in range 1980-65535."
  }

  # # For prod env
  validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "External port for dev env must be in range 1880-1979."
  }
}

variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

locals {
  container_count = length(var.ext_port[terraform.workspace])
}