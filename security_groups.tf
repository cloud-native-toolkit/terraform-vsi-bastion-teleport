##############################################################################
# Defaults for VSI security group
##############################################################################

locals {
  security_group_rule_object = {

    ##############################################################################
    # Inbound rules
    ##############################################################################

    allow_tcp_in_22 = {
      direction = "inbound"
      tcp = {
        port_min = 22,
        port_max = 22
      }
    }

    allow_tcp_in_3023_3025 = {
      direction = "inbound"
      tcp = {
        port_min = 3023,
        port_max = 3025
      }
    }

    allow_tcp_in_3080 = {
      direction = "inbound"
      tcp = {
        port_min = 3080,
        port_max = 3080
      }
    }


    ##############################################################################


    ##############################################################################
    # Outbound rules
    ##############################################################################

    allow_tcp_out_443 = {
      direction = "outbound"
      tcp = {
        port_min = 443,
        port_max = 443
      }
    }

    allow_tcp_out_3023_3025 = {
      direction = "outbound"
      tcp = {
        port_min = 3023,
        port_max = 3025
      }
    }

    allow_tcp_out_3080 = {
      direction = "outbound"
      tcp = {
        port_min = 3080,
        port_max = 3080
      }
    }

    ##############################################################################


    ##############################################################################
    # DNS Rules
    ##############################################################################

    allow_dns_1_out = {
      direction = "outbound"
      remote    = "161.26.0.7"
    }

    allow_dns_2_out = {
      direction = "outbound"
      remote    = "161.26.0.8"
    }

    allow_dns_3_out = {
      direction = "outbound"
      remote    = "161.26.0.10"
    }

    allow_dns_4_out = {
      direction = "outbound"
      remote    = "161.26.0.11"
    }

    ##############################################################################
  }
}

##############################################################################


##############################################################################
# Create Teleport Security Group
##############################################################################

resource "ibm_is_security_group" "teleport_security_group" {
  name = "${var.prefix}-teleport-security-group"
  vpc  = data.ibm_is_vpc.vpc.id
}

resource "ibm_is_security_group_rule" "vsi_security_group_rules" {
  for_each  = local.security_group_rule_object
  group     = ibm_is_security_group.teleport_security_group.id
  direction = each.value.direction
  remote    = lookup(each.value, "remote", null)

  dynamic "tcp" {
    for_each = lookup(each.value, "tcp", null) == null ? [] : [each.value]
    content {
      port_min = each.value.tcp.port_min
      port_max = each.value.tcp.port_max
    }
  }

  dynamic "udp" {
    for_each = lookup(each.value, "udp", null) == null ? [] : [each.value]
    content {
      port_min = each.value.udp.port_min
      port_max = each.value.udp.port_max
    }
  }

  dynamic "icmp" {
    for_each = lookup(each.value, "icmp", null) == null ? [] : [each.value]
    content {
      type = each.value.icmp.type
      code = each.value.icmp.code
    }
  }
}

##############################################################################


##############################################################################
# Additional Security Groups
##############################################################################

data "ibm_is_security_group" "security_group" {
  for_each = toset(var.security_group_names)
  name     = each.key
}

##############################################################################


##############################################################################
# Combine all secuirty group ids
##############################################################################

locals {
  security_group_ids = concat(
    [
      ibm_is_security_group.teleport_security_group.id
    ],
    [
      for group in data.ibm_is_security_group.security_group :
      group.id
    ]
  )
}

##############################################################################