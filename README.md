# VSI Bastion module

IBM Virtual Private Cloud (VPC) comes with an additional layer of security as your workload can be completely hidden from the public internet. There are times, however, when you will want to get into this private network. A common practice is to use a Bastion host to jump into your VPC from a machine outside of the private network. 

This module deploys a bastion server using Teleportinside a VPC Virtual Server Instance (VSI) using Terraform.

## Table of Contents

1. [Prereqs](##prereqs)
2. [Example Usage](##example-usage)
3. [Module Variables](##module-variables)

## Prereqs

1. Provision an instance of Object Storage and configure a bucket for storing session recordings.
1. Provision an instance of App ID and configure a SAML-based identity provider.
1. Acquire a Teleport Enterprise Edition license

### Command-line tools

- terraform - v1.0 or greater

### Terraform providers

- IBM Cloud provider >= 1.31

## Example usage

```hcl-terraform
module bastion {
  source                  = "github.com/cloud-native-toolkit/terraform-vsi-bastion-teleport"
  prefix                  = var.prefix                    # Prefix to add to the name of each bastion host
  resource_group          = var.resource_group            # Name of resource group where resources are provisioned
  vpc_name                = var.vpc_name                  # Name of VPC
  subnet_names            = var.subnet_names              # Names of subnets where a bastion VSI will be created
  ssh_key_names           = var.ssh_key_names             # List of SSH key names to use to create the VSI
  appid_name              = var.appid_name                # Name of App ID instance
  appid_resource_key_name = var.appid_resource_key_name   # Name of App ID resource key
  cos_name                = var.cos_name                  # Name of COS instance
  cos_resource_key_name   = var.cos_resource_key_name     # Name of COS resource key
  cos_bucket              = var.cos_bucket                # Object describing COS bucket
  teleport_license_pem    = var.teleport_license_pem      # Teleport license
  https_cert              = var.https_cert                # HTTP Cert
  https_key               = var.https_key                 # HTTP Key
  domain                  = var.domain                    # Domain for teleport
  teleport_version        = var.teleport_version          # Teleport version
  claims_to_roles         = var.claims_to_roles           # List of roles for claims
  message_of_the_day      = var.message_of_the_day        # Banner message to show to user during authentication
  security_group_names    = var.security_group_names      # Names of additional security groups to add to VSI
  image_name              = var.image_name                # Name of the image to use for the VSI
  profile                 = var.profile                   # Name of the image profile to use for VSI
}

```

## Module Variables

Name                    | Type                                                           | Description
----------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------
prefix                  | string                                                         | A unique identifier need to provision resources. Must begin with a letter
resource_group          | string                                                         | Name of resource group where all infrastructure will be provisioned
vpc_name                | string                                                         | The name of the VPC where VSI will be deployed
subnet_names            | list(string)                                                   | A list of subnets name in VPC where VSI will be created
ssh_key_names           | list(string)                                                   | A list of ssh key names to be used for access to the bastion host
appid_name              | string                                                         | Name of APP ID instance
appid_resource_key_name | string                                                         | Name of the APP ID instance resource key
cos_name                | string                                                         | Name of COS instance
cos_resource_key_name   | string                                                         | Name of the COS instance resource key. Must be HMAC credentials
cos_bucket              | object({ name = string region = string bucket_type = string }) | Data of the COS bucket to store the session recordings
teleport_license_pem    | string                                                         | The contents of the PEM license file
https_cert              | string                                                         | The https certificate
https_key               | string                                                         | The https key
domain                  | string                                                         | The domain of the instance or bastion host
teleport_version        | string                                                         | Version of Teleport Enterprise to use
claims_to_roles         | list( object({ email = string roles = list(string) }) )        | A list of maps that contain the user email and the role you want to associate with them
message_of_the_day      | string                                                         | Banner message the is exposed to the user at authentication time
security_group_names    | list(string)                                                   | A list of additional security groups to add to the primary interface of the VSI
image_name              | string                                                         | The image name to be used for the bastion host. Use `ibmcloud is images` to list image names.
profile                 | string                                                         | The profile to be used for the bastion host