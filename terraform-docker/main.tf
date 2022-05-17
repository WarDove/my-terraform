terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }

  volumes {
    container_path = "/data"
    host_path      = "/home/ubuntu/environment/my-terraform/terraform-docker/docker-volumes/nodered_data"
  }

}


output "container-name1" {
  value       = docker_container.nodered_container[0].name
  description = "The name of the container"
}

output "container-address1" {
  value       = format("http://%s", join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external]))
  description = "The name of the container"
}

output "container-name2" {
  value       = docker_container.nodered_container[1].name
  description = "The name of the container"
}

output "container-address2" {
  value       = format("http://%s", join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external]))
  description = "The name of the container"
}