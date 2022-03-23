##############################################################################
# Create Template Data to be used by Teleport VSI
##############################################################################

locals {
  user_data = templatefile(
    "./cloud-init.tpl",
    {
      TELEPORT_LICENSE          = base64encode(var.teleport_license_pem),
      HTTPS_CERT                = base64encode(var.https_cert),
      HTTPS_KEY                 = base64encode(var.https_key),
      HOSTNAME                  = "${var.prefix}-teleport-vsi",
      DOMAIN                    = var.domain,
      COS_BUCKET                = var.cos_bucket.name,
      COS_BUCKET_ENDPOINT       = ibm_cos_bucket.cos_bucket.s3_endpoint_private,
      HMAC_ACCESS_KEY_ID        = ibm_resource_key.cos_resource_key.credentials["cos_hmac_keys.access_key_id"],
      HMAC_SECRET_ACCESS_KEY_ID = ibm_resource_key.cos_resource_key.credentials["cos_hmac_keys.secret_access_key"],
      APPID_CLIENT_ID           = data.ibm_resource_key.appid_resource_key.credentials["clientId"],
      APPID_CLIENT_SECRET       = data.ibm_resource_key.appid_resource_key.credentials["secret"],
      APPID_ISSUER_URL          = data.ibm_resource_key.appid_resource_key.credentials["oauthServerUrl"],
      TELEPORT_VERSION          = var.teleport_version,
      CLAIM_TO_ROLES            = var.claims_to_roles,
      MESSAGE_OF_THE_DAY        = var.message_of_the_day
    }
  )
}

data "template_cloudinit_config" "cloud_init" {
  base64_encode = false
  gzip          = false
  part {
    content = local.user_data
  }
}

##############################################################################