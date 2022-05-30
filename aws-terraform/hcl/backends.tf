terraform {
  cloud {
    organization = "wardove"

    workspaces {
      name = "dev"
    }
  }
}