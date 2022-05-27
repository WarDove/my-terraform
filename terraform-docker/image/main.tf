resource "docker_image" "container_image" {
  name = var.image_in
  // or name = lookup(var.image, terraform.workspace)
}