resource "docker_image" "nodered_image" {
  name = var.image_in
  // or name = lookup(var.image, terraform.workspace)
}