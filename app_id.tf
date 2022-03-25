
##############################################################################
# Create App ID
##############################################################################

resource ibm_resource_instance new_appid {
    count = var.createNew==true ? 1 : 0
    name     = var.new_appid.name
    service  = "appid"
    plan     = "graduated-tier"
    location = var.new_appid.location
}

resource ibm_resource_key new_appid_resource_key {
  count = var.createNew==true ? 1 : 0
  name                 = var.new_appid_resource_key_name
  resource_instance_id = resource.ibm_resource_instance.new_appid[0].id
  role                 = "Writer"
}

resource "ibm_appid_redirect_urls" "urls" {
    
    tenant_id = var.createNew==true ? resource.ibm_resource_instance.new_appid[0].guid : data.ibm_resource_instance.appid[0].guid
    urls = [
        "https://${var.hostname}.${var.domain}:3080/v1/webapi/oidc/callback"

    ]
}
##############################################################################

##############################################################################
# App ID Data
##############################################################################

data ibm_resource_instance appid {
  count = var.createNew==false ? 1 : 0
  name              = var.appid_name
  resource_group_id = data.ibm_resource_group.resource_group.id
}

data ibm_resource_key appid_resource_key {
  count = var.createNew==false ? 1 : 0
  name                 = var.new_appid_resource_key_name
  resource_instance_id = data.ibm_resource_instance.appid[0].id
}

##############################################################################
