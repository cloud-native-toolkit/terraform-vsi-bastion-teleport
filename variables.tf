variable "vpc" {
   description = "The name of the VPC to deploy the bastion host"
   type = string
}

variable "subnet" {
  description = "The subnet name to which to provision the bastion in"
  type = string
}

variable "hostname" {
  description = "The name of the instance or bastion host"
  type = string
}

variable "resource_group" {
  description = "The name of the resource_group to provision things in"
  type = string
}

variable "domain" {
  description = "The domain of the instance or bastion host"
  type = string
}

variable "image" {
  description = "The image to be used for the bastion host"
  type = string
}

variable "extra_security_groups" {
  description = "A list of extra security groups to add to the primary interface"
  type = list 
  default = []
}

variable "profile" {
  description = "The profile to be used for the bastion host"
  type = string
}

variable "ssh_key_names" {
  description = "A list of ssh key names to be used for access to the bastion host"
  type = list
  default = []
}

variable "license" {
  description = "The contents of the PEM license file"
  type = string
}

variable "https_cert" {
  description = "The https certificate"
  type = string 
}

variable "https_key" {
  description = "The https key"
  type = string
}

######################################
# COS variables
######################################
variable "cos_instance_crn" {
  description = "The crn of the cos instance"
  type = string
}

variable "cos_bucket" {
  description = "The bucket to store the session recordings"
  type = string
}

variable "cos_bucket_endpint" {
  description = "The endpoint of the cos bucket"
  type = string
}

variable "cos_resource_key_name" {
  description = "The name of the COS service key to be used"
  type = string
}

######################################
# APPID variables
######################################
variable "appid_instance_crn" {
  description = "The crn of the appid instance"
  type = string
}

variable "appid_resource_key_name" {
  description = "The name of the AppID service key to be used"
  type = string
}


#######################
# Teleport variables
#######################

variable "teleport_version" {
  description = "Version of Teleport Enterprise to use"
  type = string
  default = "7.1.3"
}

#### Example
#{
#    email = "user@test.com,
#    roles = ["teleport-admin"]
#  },
#  {
#    email = "test@gmail.com",
#    roles = ["teleport-admin2"]
#  }
#]
variable "claims_to_roles" {
  description = "A list of maps that contain the user email and the role you want to associate with them"
  type = list 
}

variable "message_of_the_day" {
  description = "Banner message the is exposed to the user at authentication time"
  type = string
  default = ""
}
