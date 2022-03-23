
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

# resource "ibm_cos_bucket" "cos_bucket" {
#   resource_instance_id = ibm_resource_instance.cos.id
#   bucket_name          = var.cos_bucket.name
#   region_location      = var.cos_bucket.region
#   storage_class        = "standard"
#   retention_rule {
#     default   = 360
#     maximum   = 360
#     minimum   = 360
#     permanent = false
#   }
# }

resource "ibm_resource_key" "cos_resource_key" {
  name                 = var.cos_resource_key_name
  resource_instance_id = ibm_resource_instance.cos.id
  parameters           = { "HMAC" = true }
  role                 = "Writer"
}
##############################################################################

