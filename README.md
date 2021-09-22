# VSI Bastion module

IBM Virtual Private Cloud (VPC) comes with an additional layer of security as your workload can be completely hidden from the public internet. There are times, however, when you will want to get into this private network. A common practice is to use a Bastion host to jump into your VPC from a machine outside of the private network. 

This module deploys a bastion server using Teleportinside a VPC Virtual Server Instance (VSI) using Terraform.

## Prereqs

1. Provision an instance of Object Storage and configure a bucket for storing session recordings.
1. Provision an instance of App ID and configure a SAML-based identity provider.
1. Acquire a Teleport Enterprise Edition license

### Command-line tools

- terraform - v13

### Terraform providers

- IBM Cloud provider >= 1.31

## Example usage

```hcl-terraform
module "bastion" {
  source = "github.com/cloud-native-toolkit/terraform-vsi-bastion-teleport"
  vpc                 = var.vpc                           #Name of the VPC
  subnet              = var.subnet                        #Name of the subnet
  hostname            = var.hostname                      #Name of the hostname of this instance
  resource_group      = var.resource_group_name           #Name of the resource group
  domain              = var.domain                        #The domain of this instance
  image               = var.image                         #The image ID of the instance
  extra_security_groups = var.extra_security_groups       #List of security group names to attach to the interface
  ssh_key_names       = var.ssh_key_names                 #The ssh key names to use for this instance
  license             = var.license                       #The Teleport license contents
  https_cert          = var.https_cert                    #The certificate to use for https
  https_key           = var.https_key                     #The key to use for https
  cos_instance_crn    = var.cos_instance_crn              #The crn of the cos instance
  cos_bucket          = var.cos_bucket                    #The cos bucket name to store session recordings
  cos_bucket_endpoint  = var.cos_bucket_endpint           #The endpoint of the cos bucket
  cos_resource_key_name = var.cos_resource_key_name       #The name of the resource key to use
  appid_instance_crn    = var.appid_instance_crn          #The crn of the appid provisioned instance
  appid_resource_key_name = var.appid_resource_key_name   #The name of the resource key to use in appid
  claims_to_roles         = var.claims_to_roles           #The email and roles to associate for a claim
  message_of_the_day      = var.message_of_the_day        #Banner message to show the user during authentication
}
```
