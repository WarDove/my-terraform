terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

provider "docker" {}


resource "null_resource" "nodered_data" {
  provisioner "local-exec" {
    command = <<-EOT
    mkdir -p docker-volumes/nodered_data || true
    chown -R 1000:1000 docker-volumes/nodered_data
    EOT
  }
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = local.container_count

  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }

  volumes {
    container_path = "/data"
    host_path      = "/home/ubuntu/environment/my-terraform/terraform-docker/docker-volumes/nodered_data"
  }

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

