# Create the DC
resource "vsphere_datacenter" "azin-sphere-dc" {
  name = var.dc_name
}

# Add underlying hosts into DC
resource "vsphere_host" "esx-01" {
  hostname   = var.esx-01_server
  username   = var.esx-01_user
  password   = var.esx-01_password
  datacenter = vsphere_datacenter.azin-sphere-dc.moid

  lifecycle {
    ignore_changes = [
      cluster
    ]
  }

}

# Add Compute Cluster
resource "vsphere_compute_cluster" "azin-sphere-cc" {
  name            = "azin-sphere compute cluster"
  datacenter_id   = vsphere_datacenter.azin-sphere-dc.moid
  host_system_ids = [vsphere_host.esx-01.id]

  drs_enabled = false
  ha_enabled  = false
}

# #Add Resource pool
# resource "vsphere_resource_pool" "azin-sphere-rp" {
#   name                    = "azin-sphere-rp"
#   parent_resource_pool_id = vsphere_compute_cluster.azin-sphere-cc.resource_pool_id
# }

# resource "vsphere_folder" "folder" {
#   path          = "consul"
#   type          = "vm"
#   datacenter_id = data.vsphere_datacenter.azin-sphere-dc.id
# }