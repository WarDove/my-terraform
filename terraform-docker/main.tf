
# resource "null_resource" "nodered_data" {
#   provisioner "local-exec" {
#     command = <<-EOT
#     mkdir -p docker-volumes/nodered_data || true
#     chown -R 1000:1000 docker-volumes/nodered_data
#     EOT
#   }
# }


locals {
  deployment = {
    nodered = {
      container_count = length(var.ext_port.nodered[terraform.workspace])
      image           = var.image.nodered[terraform.workspace]
      ext_port        = var.ext_port.nodered[terraform.workspace]
      int_port        = var.int_port.nodered
      container_path  = "/data"
    }
    influxdb = {
      container_count = length(var.ext_port.influxdb[terraform.workspace])
      image           = var.image.influxdb[terraform.workspace]
      ext_port        = var.ext_port.influxdb[terraform.workspace]
      int_port        = var.int_port.influxdb
      container_path  = "/var/lib/influxdb"
    }
    grafana = {
      container_count = length(var.ext_port.grafana[terraform.workspace])
      image           = var.image.grafana[terraform.workspace]
      ext_port        = var.ext_port.grafana[terraform.workspace]
      int_port        = var.int_port.grafana
      container_path  = "/var/lib/grafana"
    }
  }
}

module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image
}

module "container" {
  source = "./container"
  # depends_on  = [null_resource.nodered_data]
  #count       = local.container_count
  for_each    = local.deployment
  count_in    = each.value.container_count
  name_in     = each.key
  image_in    = module.image[each.key].image_out
  int_port_in = each.value.int_port
  ext_port_in = each.value.ext_port
  // or ext_port_in = lookup(var.ext_port, terraform.workspace)[count.index]
  container_path_in = each.value.container_path
  #host_path_in      = "${path.cwd}/docker-volumes/nodered_data"
}


# THESE RESOURCES WERE MEANT FOR IMPORTS

# resource "docker_container" "nodered_container-2" {
#   name  = "nodered-e3y2"
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     #external = 1880
#   }

#   volumes {
#     container_path = "/data"
#     host_path      = "/home/ubuntu/environment/my-terraform/terraform-docker/docker-volumes/nodered_data"
#   }

# }

# resource "docker_container" "nodered_container-3" {
#   name  = "nodered-gadb"
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     #external = 1880
#   }

#   volumes {
#     container_path = "/data"
#     host_path      = "/home/ubuntu/environment/my-terraform/terraform-docker/docker-volumes/nodered_data"
#   }

# }

