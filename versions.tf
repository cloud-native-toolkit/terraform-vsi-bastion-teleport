variable "ibmcloud_api_key" {}
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.32.1"
    }
    template = {
      source = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}
# Configure the IBM Provider
provider "ibm" {
  ibmcloud_api_key   = var.ibmcloud_api_key
  region = "us-south"
}
