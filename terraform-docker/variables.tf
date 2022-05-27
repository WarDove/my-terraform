variable "image" {
  type        = map(any)
  description = "Container Image"
  default = {
    nodered = {
      dev  = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
    }
    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2"
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }
    grafana = {
      dev  = "grafana/grafana-oss:latest"
      prod = "grafana/grafana-oss:main"
    }
  }

}

variable "ext_port" {
  type = map(any)
  # For dev env
  # validation {
  #   condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
  #   error_message = "External port for dev env must be in range 1980-65535."
  # }

  # # # For prod env
  # validation {
  #   condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
  #   error_message = "External port for dev env must be in range 1880-1979."
  # }
}

variable "int_port" {
  type = map(any)

  # validation {
  #   condition     = var.int_port == 1880
  #   error_message = "The internal port must be 1880."
  # }
}


