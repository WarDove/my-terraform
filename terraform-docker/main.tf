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

resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    external = 1880
  }

  volumes {
    container_path = "/data"
    host_path      = "/home/ubuntu/environment/my-terraform/terraform-docker/docker-volumes/nodered_data"
  }

}


output "container-name" {
  value       = docker_container.nodered_container.name
  description = "The name of the container"
}

output "container-ip-port" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "The name of the container"
}

output "container-ip-port-schema" {
  value       = format("http://%s",join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external]))
  description = "The name of the container"
}