#output "myoutput" {
#  description = "Description of my output"
#  value       = "value"
#  depends_on  = [<some resource>]
#}

output "myoutput" {
 description = "Description of my output"
 value       = var.resource_group

}
output "instance_ip_addr" {
    value = ibm_cos_bucket.cos_bucket

}
