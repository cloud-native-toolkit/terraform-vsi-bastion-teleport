##############################################################################
# Resource Group where VSI Resources Will Be Created
##############################################################################

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

##############################################################################


##############################################################################
# VPC Data
##############################################################################

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

data "ibm_is_subnet" "subnet" {
  for_each = toset(var.subnet_names)
  name     = each.key
}

data "ibm_is_ssh_key" "ssh_key" {
  for_each = toset(var.ssh_key_names)
  name     = each.key
}

##############################################################################


##############################################################################
# App ID Data
##############################################################################

data "ibm_resource_instance" "appid" {
  name              = var.appid_name
  resource_group_id = data.ibm_resource_group.resource_group.id
}

data "ibm_resource_key" "appid_resource_key" {
  name                 = var.appid_resource_key_name
  resource_instance_id = data.ibm_resource_instance.appid.id
}

##############################################################################


##############################################################################
# COS Instance
##############################################################################

resource "ibm_resource_instance" "cos" {
  name              = var.cos_name
  resource_group_id = data.ibm_resource_group.resource_group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
}

resource "ibm_cos_bucket" "cos_bucket" {
  resource_instance_id = ibm_resource_instance.cos.id
  bucket_name          = var.cos_bucket.name
  region_location      = var.cos_bucket.region
  storage_class        = "standard"
  retention_rule {
    default   = 360
    maximum   = 360
    minimum   = 360
    permanent = false
  }
}

resource "ibm_resource_key" "cos_resource_key" {
  name                 = var.cos_resource_key_name
  resource_instance_id = ibm_resource_instance.cos.id
  parameters           = { "HMAC" = true }
  role                 = "Writer"
}
##############################################################################


##############################################################################
# Teleport Instance
##############################################################################

data "ibm_is_image" "vsi_image" {
  name = var.image_name
}

resource "ibm_is_instance" "teleport_vsi" {
  for_each       = toset(var.subnet_names)
  name           = "${var.prefix}-teleport-vsi-${index(var.subnet_names, each.key) + 1}"
  image          = data.ibm_is_image.vsi_image.id
  profile        = var.profile
  resource_group = data.ibm_resource_group.resource_group.id
  vpc            = data.ibm_is_vpc.vpc.id
  zone           = data.ibm_is_subnet.subnet[each.key].zone
  user_data      = data.template_cloudinit_config.cloud_init.rendered # From templates.tf

  primary_network_interface {
    subnet          = data.ibm_is_subnet.subnet[each.key].id
    security_groups = local.security_group_ids # From security_groups.tf
  }

  keys = [
    for ssh_key in data.ibm_is_ssh_key.ssh_key :
    ssh_key.id
  ]

  # User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

##############################################################################