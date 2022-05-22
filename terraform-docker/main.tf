
resource "null_resource" "nodered_data" {
  provisioner "local-exec" {
    command = <<-EOT
    mkdir -p docker-volumes/nodered_data || true
    chown -R 1000:1000 docker-volumes/nodered_data
    EOT
  }
}


module "image" {
  source   = "./image"
  image_in = var.image[terraform.workspace]
}


resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = local.container_count

  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = module.image.image_out
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
    // or external = lookup(var.ext_port, terraform.workspace)[count.index]
  }

  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/docker-volumes/nodered_data"
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

