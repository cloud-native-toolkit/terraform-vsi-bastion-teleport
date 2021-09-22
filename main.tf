data "ibm_resource_group" "rg" {
  name = var.resource_group
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc
}

data "ibm_is_subnet" "subnet" {
  name = var.subnet
}

data "ibm_is_ssh_key" "ssh_key" {
  for_each = toset(var.ssh_key_names)
  name = each.key
}

data "ibm_resource_key" "cos_resourceKey" {
  name                  = var.cos_resource_key_name
  resource_instance_id  = var.cos_instance_crn
}

data "ibm_resource_key" "appid_resourceKey" {
  name                  = var.appid_resource_key_name
  resource_instance_id  = var.appid_instance_crn
}

locals {
   user_data = templatefile("./cloud-init.tpl", 
    { TELEPORT_LICENSE = base64encode(var.license), 
      HTTPS_CERT =  base64encode(var.https_cert), 
      HTTPS_KEY = base64encode(var.https_key),
      HOSTNAME = var.hostname,
      DOMAIN = var.domain,
      COS_BUCKET = var.cos_bucket,
      COS_BUCKET_ENDPOINT = var.cos_bucket_endpint,
      HMAC_ACCESS_KEY_ID = data.ibm_resource_key.cos_resourceKey.credentials["cos_hmac_keys.access_key_id"],
      HMAC_SECRET_ACCESS_KEY_ID = data.ibm_resource_key.cos_resourceKey.credentials["cos_hmac_keys.secret_access_key"],
      APPID_CLIENT_ID = data.ibm_resource_key.appid_resourceKey.credentials["clientId"],
      APPID_CLIENT_SECRET = data.ibm_resource_key.appid_resourceKey.credentials["secret"], 
      APPID_ISSUER_URL = data.ibm_resource_key.appid_resourceKey.credentials["oauthServerUrl"],
      TELEPORT_VERSION = var.teleport_version,
      CLAIM_TO_ROLES = var.claims_to_roles,
      MESSAGE_OF_THE_DAY = var.message_of_the_day })
}

data "template_cloudinit_config" "cloud-init" {
   base64_encode = false
   gzip = false
   part {
     content = local.user_data
   }
}

resource "ibm_is_security_group" "bastion_security_group" {
  name = "bastion-${var.subnet}-sg"
  vpc  = data.ibm_is_vpc.vpc.id
}

locals {
  ingress_tcp_rules = [
    { 
      port_min = 22,
      port_max = 22
    },
    { 
      port_min = 3023,
      port_max = 3025
    },
    { 
      port_min = 3080,
      port_max = 3080
    }
  ]
  outgress_tcp_rules = [
    { 
      port_min = 443,
      port_max = 443
    },
    { 
      port_min = 3023,
      port_max = 3025
    },
    { 
      port_min = 3080,
      port_max = 3080
    }
  ]
  dns_server_addresses =  ["161.26.0.7", "161.26.0.8", "161.26.0.10", "161.26.0.11"]
}

resource "ibm_is_security_group_rule" "bastion_sg_inbound_rules" {
  group     = ibm_is_security_group.bastion_security_group.id
  direction = "inbound"
  dynamic "tcp" {
    for_each = local.ingress_tcp_rules
    content {
      port_min = tcp.value.port_min
      port_max = tcp.value.port_max
    }
  }
}

resource "ibm_is_security_group_rule" "bastion_sg_outbound_rules" {
  group     = ibm_is_security_group.bastion_security_group.id
  direction = "outbound"
  dynamic "tcp" {
    for_each = local.outgress_tcp_rules
    content {
      port_min = tcp.value.port_min
      port_max = tcp.value.port_max
    }
  }
}

resource "ibm_is_security_group_rule" "bastion_sg_outbound_dns_rules" {
  for_each = toset(local.dns_server_addresses)
  group     = ibm_is_security_group.bastion_security_group.id
  direction = "outbound"
  remote = each.key
}

data "ibm_is_security_group" "extra_sgs" {
  for_each = toset(var.extra_security_groups)
  name = each.key
}


resource "ibm_is_instance" "instance" {
  name    =  var.hostname
  image   =  var.image
  profile =  var.profile
  resource_group = data.ibm_resource_group.rg.id

  primary_network_interface {
    subnet = data.ibm_is_subnet.subnet.id
    security_groups = concat([ibm_is_security_group.bastion_security_group.id], [for sg in var.extra_security_groups : data.ibm_is_security_group.extra_sgs[sg].id])
  }

  vpc  = data.ibm_is_vpc.vpc.id
  zone = data.ibm_is_subnet.subnet.zone
  keys = [ for k in var.ssh_key_names : data.ibm_is_ssh_key.ssh_key[k].id ]

  user_data = data.template_cloudinit_config.cloud-init.rendered

  //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_is_floating_ip" "floatingip" {
 name   = "cloud-init-ip"
 target = ibm_is_instance.instance.primary_network_interface[0].id
}

