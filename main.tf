##############################################################################
# Resource Group where VSI Resources Will Be Created
##############################################################################

data ibm_resource_group resource_group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# VPC Data
##############################################################################

data ibm_is_vpc vpc {
  name = var.vpc_name
}

data ibm_is_subnet subnet {
  for_each = toset(var.subnet_names)
  name     = each.key
}

data ibm_is_ssh_key ssh_key {
  for_each = toset(var.ssh_key_names)
  name     = each.key
}

##############################################################################

##############################################################################
# Teleport Instance
##############################################################################

data ibm_is_image vsi_image {
  name = var.image_name
}

resource ibm_is_instance teleport_vsi {
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