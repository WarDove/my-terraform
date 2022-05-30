resource "random_string" "random" {
  count   = var.count_in
  length  = 8
  special = false
  upper   = false
}

resource "docker_container" "app_container" {
  count = var.count_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  image = var.image_in
  networks_advanced {
    name = var.network_in
  }
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }
  dynamic "volumes" {
    for_each = var.volumes_in
    content {
      container_path = volumes.value["container_path_each"]
      volume_name    = module.volumes[count.index].volumes_out[volumes.key]
    }
  }
  provisioner "local-exec" {
    command = "echo '${self.name}: ${self.ip_address}:${self.ports[0].external}' >> ${path.cwd}/container.txt"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm ${path.cwd}/container.txt"
    on_failure = continue
  }
}

module "volumes" {
  source     = "./volumes"
  count      = var.count_in
  volumes_in = var.volumes_in
  name_in    = "${var.name_in}-${random_string.random[count.index].result}-vol"
}



resource "docker_volume" "container_volume" {
  count = var.count_in

  lifecycle {
    prevent_destroy = false
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../vol-backups"
    on_failure = continue
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "sudo tar -cvzf ${path.cwd}/../vol-backups/${self.name}.tar.gz ${self.mountpoint}/"
    on_failure = fail
  }
}