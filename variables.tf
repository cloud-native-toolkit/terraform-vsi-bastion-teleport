##############################################################################
# Account Variables
# Copyright 2020 IBM
##############################################################################

variable prefix {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
    }
    default="g5g55g5g"
}

variable resource_group {
    description = "Name of resource group where all infrastructure will be provisioned"
    type        = string

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
    }
    default="default"
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable vpc_name {
   description = "The name of the VPC where VSI will be deployed"
   type        = string
   default="vpc-test-vidhi"
}

variable subnet_names {
    description = "A list of subnets name in VPC where VSI will be created"
    type        = list(string)
    default=["bastion-subnet"] 

    validation {
      error_message = "At least one subnet name must be provided."
      condition     = length(var.subnet_names) > 0
    }

    validation  {
      error_message = "Each subnet name in the list must be unique."
      condition     = length(var.subnet_names) == length(distinct(var.subnet_names))
    }
}

variable ssh_key_names {
  description = "A list of ssh key names to be used for access to the bastion host"
  type       = list(string)
  default = ["vidhi-mac-new","vrh-new-mac"]

  validation {
    error_message = "At least one SHH key name must be provided."
    condition     = length(var.ssh_key_names) > 0
  }
  
  validation  {
      error_message = "Each ssh key name in the list must be unique."
      condition     = length(var.ssh_key_names) == length(distinct(var.ssh_key_names))
  }
}

##############################################################################


##############################################################################
# APP ID Variables
##############################################################################

variable appid_name { 
  description = "Name of APP ID instance"
  type        = string
  default = "App ID-vidhi"
}

variable appid_resource_key_name {
  description = "Name of the APP ID instance resource key"
  type        = string
  default="vidhi-fs-cloud-appid"
}

##############################################################################


##############################################################################
# COS Variables
##############################################################################

variable cos_name { 
  description = "Name of COS instance"
  type        = string
  default="dr-cos-instance"
}

variable cos_resource_key_name {
  description = "Name of the COS instance resource key. Must be HMAC credentials"
  type        = string
  default="dr-resource-key"
}

variable cos_bucket { 
  description = "Data of the COS bucket to store the session recordings"
  type        = object({
    name        = string
    region      = string
    bucket_type = string
  })
  default={
    name="dr-bucket-test1"
    region="us-south"
    bucket_type="region_location"
  }
  validation {
    error_message = "Cos bucket type can only be one of `single_site_location`, `region_location`, `cross_region_location."
    condition     = var.cos_bucket.bucket_type == "single_site_location" || var.cos_bucket.bucket_type == "region_location" || var.cos_bucket.bucket_type == "cross_region_location" 
  }
}

##############################################################################


##############################################################################
# Template Variables
##############################################################################

variable teleport_license_pem {
  description = "The contents of the PEM license file"
  type        = string
  default="-----BEGIN CERTIFICATE-----\nMIIEdTCCA12gAwIBAgIUR3ouYHZcU8QLGS33PbJdpp2aDeMwDQYJKoZIhvcNAQEL\nBQAwJjEkMCIGA1UEAxMbZGFzaGJvYXJkLmdyYXZpdGF0aW9uYWwuY29tMCAXDTE5\nMTIwMzA0NTQ1MFoYDzIxMTkxMTA5MDU1NDUwWjAtMRkwFwYDVQQKExBncmF2aXRh\ndGlvbmFsLmlvMRAwDgYDVQQDEwdsaWNlbnNlMIIBIjANBgkqhkiG9w0BAQEFAAOC\nAQ8AMIIBCgKCAQEA3TBJgKjMk5poMsQM6CpgXRBdS2xQowwBwLvyBT39XGzXMEgm\nu4yps0wudj2Tdm2z5xXnjvB/rIR0Lxt7N4e3O90ICxWhF48ArE4xDNRX5sxjtmt7\n0mS+O1R2sQ0cfYaju4JXpIBn6wpOjskA5FHoNh3seMM1zj5asjeCE423vu0RMn6z\nZjzIS97ZD60JfTp28kJMJers2K77fOm4VfPjD8jVjOjBX5kScyQzBX3WIdEvQWEk\n3BGyqbjUARjHIfsi/PEDiFDh0QzEhFUGTe17IeyAl56WpA6HM0Gn5xq9EPw0uaoe\n6YJHQrv6ugGLbdre9Du3cjnFSUsL3bWx+ObnxwIDAQABo4IBkDCCAYwwDgYDVR0P\nAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAMBgNVHRMB\nAf8EAjAAMB0GA1UdDgQWBBRoSUugAzcMwGuNnMEL/YI+uyIMHjAfBgNVHSMEGDAW\ngBQ8OMNT/LK7u7LOPbz88vqM0s3kFTAPBgNVHREECDAGhwR/AAABMIH7BgJVKgSB\n9Hsia2luZCI6ImxpY2Vuc2UiLCJ2ZXJzaW9uIjoidjMiLCJtZXRhZGF0YSI6eyJu\nYW1lIjoiYjU1MzJhNTYtYzRiZC00ODQ5LTk4MmUtOGM3ODkzNGE2ZDM2IiwibGFi\nZWxzIjp7IkVtYWlsIjoic3RtdXJha2FAdXMuaWJtLmNvbSJ9LCJleHBpcmVzIjoi\nMjExOS0xMS0wOVQwNTo1NDo1MC4zODY0MTYwODNaIn0sInNwZWMiOnsiYWNjb3Vu\ndF9pZCI6ImN1c19FamVXbkpPeEhvanV0RyIsIms4cyI6dHJ1ZSwidXNhZ2UiOmZh\nbHNlfX0wDQYJKoZIhvcNAQELBQADggEBANzqjgmLsc0ErjVHzXw9UNffuOfGn7hV\n1yWLCZcwts2BRYfSPLnve/vU7nxYEeYrP7RgFMXJE8iOy6UhbaZX2YGBk+tKuWZx\nJ05v+ax6CeBnx2vT66MDFM+BSQd/ojulIgqBax796+uEtr9tv8k9HE1Gmm9DbDlR\nuoHfyPCEZs0i1GH5Anfa9lRT1aGyomlHI6sylgAdRdMY7QliOVwyvseE+oBSsbH9\n9JEiDh43eHzLVupJ0H35/fpsW5ME/kwJhUNJmrxsd47m5Ue6SGHqTGRXEmLOJZOb\nEEY4D0tXijbqNm7wZ/LolqPiTt0DsolnTo+yMOnc66DAB9r8bb13XXY=\n-----END CERTIFICATE-----\n-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA3TBJgKjMk5poMsQM6CpgXRBdS2xQowwBwLvyBT39XGzXMEgm\nu4yps0wudj2Tdm2z5xXnjvB/rIR0Lxt7N4e3O90ICxWhF48ArE4xDNRX5sxjtmt7\n0mS+O1R2sQ0cfYaju4JXpIBn6wpOjskA5FHoNh3seMM1zj5asjeCE423vu0RMn6z\nZjzIS97ZD60JfTp28kJMJers2K77fOm4VfPjD8jVjOjBX5kScyQzBX3WIdEvQWEk\n3BGyqbjUARjHIfsi/PEDiFDh0QzEhFUGTe17IeyAl56WpA6HM0Gn5xq9EPw0uaoe\n6YJHQrv6ugGLbdre9Du3cjnFSUsL3bWx+ObnxwIDAQABAoIBAExmem0LYSZ2xhkK\n6N5kjMZ4eZEsx6mZ4x0cjhtLbzE2kxmlQmOz0YYSAVZsLHxSpjpisYoI/kCru6nt\n1yC2Kw9taHLTtMH7biMWGxEwY3BgFu0SsUFZ9O9vXFQJkFa3Y+THv9gdVke0VrAx\nM7KprAjNSznnS7WCijdWvwJcCCTU/49JOCC9rTOo6DaseKzqrIpBaiOPJbMfPwZT\n6mkhH4e0Z2mlOy3L9eahZ4f10RzBB+XGkUZRecagxGfV59Wxmv+6sW5YfTrLt3gu\nF3gyvEnt/ZiX9jYsvmWZdzJYC4JnXDU2NVmyZ7G1+mRQEehMk7OAcXIxs2nOku1s\nghHKvoECgYEA9QfSPaKI7lmC6jrZw26o1JagX4LdCtYMuzEf/C2vX6gX/jr1pnWP\nKAmp0uJ1Oj6iKLb8rVG8nUyPomjNwSp+/AcpV2yMVP91w+BHHUdr04RcPYCFRjdc\nywXsal+4j3hLDNQuoBI0BSgXC3uvrkb8SCE5+v/NjWlA8OQmDCmRNsECgYEA5xc5\njoUntj2bgHYGs+J+e6jclEq9WV91QFW05Uao86AZtRZju46dqKfAtxZF8pvssP2l\nzy+O+QXINUNzNSbupaw4DBY6MLRPyYic0E/pC/O2MpKWAi03wwyMysShP+aIZD7i\n0Zbnd49eCatJjKDO3qhZEG5cdUP5/kAOVf/dCIcCgYEA8CqWW2swI88AjmzYfMG+\nIYDx+CvgVHqxR9lCrH5q4qtzuPA5TsrzYh72oYjttgUmFBonWApBgTxFnL50zdzF\nUmoCj3oJolYyK6dsjLowacXWU0HhX41sGmLX8vuXfqg9h3mBqcutyVAeJlc5Puy8\n4kYO+oI4C18bFAHLeShU+QECgYEAq6XFm8Xt/GCAa4e/bMgUmPeReBiX0pWj+vhu\nWEsG3YcS8T5DMCI7mvWXoKbLp+wHgGO3UFCMCw4vatjB7z4Oz0I/k0LDUD/ub8yo\nZdalTLpmn+PfxpgdriRZQ5eQCm3K62MGiRVksprsB5SSGgGsBxjWpuzCglvOifq8\na0aUwGsCgYAE+CkoLFfxnHAJAU+5vLL8KLdX/kX3QGxpxEtwQgAPR7wKnXyiV207\nuAQubC2s/ni2DqmHjkFLYL4RCTcVBUWElzaaCo9wikS6FsL+ipEeFmj9gkGOb00y\nCk078/6hzcJ4WL+bJ/gsJh2tOZ2k0rILbVI/Powx2KlUdvtzp9cUxw==\n-----END RSA PRIVATE KEY-----"
}

variable https_cert {
  description = "The https certificate"
  type        = string 
  default="-----BEGIN CERTIFICATE-----\nMIIDVDCCAjygAwIBAgIUY6i60jLsmFDkYh1R6v59VlX9SZowDQYJKoZIhvcNAQEL\nBQAwGTEXMBUGA1UEAwwONTIuMTE2LjE5NC4yMTIwHhcNMjIwMzE1MjA0NDM5WhcN\nMzIwMzEyMjA0NDM5WjAZMRcwFQYDVQQDDA41Mi4xMTYuMTk0LjIxMjCCASIwDQYJ\nKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMFX+St+KAMh+kU1Ih+nCL0U9AJCUMDs\nlEB42z6gOc7V4UFqCwBKAH41ah4XYzstsxlIajL1ckMru2MCsgRICkZFGGMq9yxr\n4yoN7gBy+cri02mmmWzwPsXnIWukKyQQLZ8VJOR5wmcqeteB67N5hKuUkeu8TBon\nJj/RNJz6/ntnTb4dEZY56+7YlN0C2smgOucwCdkIQoQXW6Jcow7jmEJbE7FHfTYC\nxWm2So1eaT0KBaZEOGx4BdiXxwqN/rDNEd/Iyw/BGjzPNvNd9y5MbN7/5nt4rMww\nEvSni4gBygHhdDX/arRNJ3W/3L5q8Ifmo3AorZEUoEEn9hHKgbC+Pa0CAwEAAaOB\nkzCBkDAdBgNVHQ4EFgQURZbKAbsMfFl0LCFDtLU7HtFsOdswVAYDVR0jBE0wS4AU\nRZbKAbsMfFl0LCFDtLU7HtFsOduhHaQbMBkxFzAVBgNVBAMMDjUyLjExNi4xOTQu\nMjEyghRjqLrSMuyYUORiHVHq/n1WVf1JmjAMBgNVHRMEBTADAQH/MAsGA1UdDwQE\nAwIBBjANBgkqhkiG9w0BAQsFAAOCAQEAajh1X5OhzHtToB8TlNsGNcAAXTgiOssB\nvKasKeJTDnOVwVAd6XG7HMHB+JQcv1WXOvX0p8lkcjMmgd/ukgSiP/VraAQTgnXn\nevNMiG+jo+L7OCxNw/f0aVYiulW0DY5atfUYk2d++obRfA8yvlzN3s9iDWv6cS0L\niFfg3UMmeOKyIMGmOVfiOCRqbidGDGphXXhMoCUKgmE1TAFq3VxqGkbRyz85fxHk\nlfSHlhrjUSoxQaO4pdMGtv2l9yIOMjGvyz6DVdkPDGcsGaolJMVg5S3tIy4+xfM2\n98tH2IMvgzLGDJHnR7pbskP5IufMsgncms0Uc9P7ceK4JrFgTA1mxw==\n-----END CERTIFICATE-----"
}

variable https_key {
  description = "The https key"
  type        = string
  default="-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAwVf5K34oAyH6RTUiH6cIvRT0AkJQwOyUQHjbPqA5ztXhQWoL\nAEoAfjVqHhdjOy2zGUhqMvVyQyu7YwKyBEgKRkUYYyr3LGvjKg3uAHL5yuLTaaaZ\nbPA+xecha6QrJBAtnxUk5HnCZyp614Hrs3mEq5SR67xMGicmP9E0nPr+e2dNvh0R\nljnr7tiU3QLayaA65zAJ2QhChBdbolyjDuOYQlsTsUd9NgLFabZKjV5pPQoFpkQ4\nbHgF2JfHCo3+sM0R38jLD8EaPM828133Lkxs3v/me3iszDAS9KeLiAHKAeF0Nf9q\ntE0ndb/cvmrwh+ajcCitkRSgQSf2EcqBsL49rQIDAQABAoIBAHwqazKrSjb40yku\n/kMlmk8T7cClpga/6FWfR+3oKDfU01yXJYmB/N8Qnp3El02iA6rw/oLLbh4FL8pe\nKMTnHvIR3Z+SMDqu7qxLVdWkARdypCLtgwqbHzUpQiVGwQ3f9ex8P70bFOX8Ofe8\n0AnquHEYcL3bp2QEUGQbjpZh+px0lCdHn6mbyZ8EF2QRBpSfs043rAEpOTKgCn9z\n+32b2NpdQqZ9QxObIQMSvMf8Ap5+KyPDPMF1Y31mNtyaN62cBCOFJt81Y8hoZDqM\nRmI+hUJgCbKXJDjsIG7CfJ97FzebuERii8lTcWpRm1dF6wq+Tc8RJqbGXQYlecxt\n+O+EuGECgYEA9a5/rPs7/Gq9x6ezoHxSqlK+KghcTbeaIxNjEGL0FWhnrEdDPHH9\nb4XL+49KTV5cbqZ4itySEVniLg3Zuil+lz9/GMQtVRo85zQWR6/7kfT8e0of+/Tl\nb1GpbU3oTAI2lMFm06LorKzYfNE3B7U4SlJbGQ+jW3tLd8sM8+MBVTsCgYEAyXbA\nPW07CGmyPbWGoqSodkR6eTwhNl52IlLwEPuxeqODBIOpM2ECPelwj+/dcqn5fUuF\nNxhgWnghQZOkCbMgb6G9ZTD7pA9G3EJd6t4Y8qeb5OyJQrkeydEzrA8JiiWzoeZl\nAm/YnT/oXLWsknKRyAdHohUL1pRPbav0XG3X6jcCgYAPSJy+uR5hNI671e3xxOor\nmFwmJ0D+wLZBClq2UUGX91fDuucu4nR+tJcc/iwEJiOf6pFDKjeYBrxwWwI5d41d\ngWC5vLKJQcmaJH5iVUtUKCZw0QquVOzVAQKGPzt9RwH4PRPVhKPu4g3Rrf47Z4Wp\n8fei1ns2HLR0LliO74dMswKBgQCv4nzzI+nl7mEufsyMMjThC+fg8B4O2WlJjh8I\ntLS93QMFbezKbmcGpkcfYspy0PJ/8O7cqut0EGz4U21jCn/G9e3j6l/HW48BvO9B\nnaUqNCpmMhujpPq8N2hlTruFYGTzc7G77umuX5z9U57WPDAJ8lEXsEgljlXJ6dXs\n2/klAQKBgFaN2SGcgdKZCpqppNwcamWN1hK3QnIwkCgPFwmlaSdoahGpZb7PAnhQ\nSQ/gcfRUk6BN8V5m+UF1KA2jHvN09keI4U0OgON0KkM23f6BMHKvCE5Of/2wSoOZ\nJIJOxNYxFQ8xjcMTC1cfIYjCnFxnIVivxbrNbBI2qs5xKgNbFg5B\n-----END RSA PRIVATE KEY-----"
}

variable domain {
  description = "The domain of the instance or bastion host"
  type        = string
  default="bastion-v9"
}

variable teleport_version {
  description = "Version of Teleport Enterprise to use"
  type        = string
  default     = "7.1.3"
}

variable claims_to_roles {
  description = "A list of maps that contain the user email and the role you want to associate with them"
  type        = list(
    object({
      email = string
      roles = list(string)
    })
  )
  default=[{"email" = "daroush.renoit@ibm.com","roles" = ["teleport-admin"]}]
  
}

variable message_of_the_day {
  description = "Banner message the is exposed to the user at authentication time"
  type        = string
  default = ""
}

##############################################################################


##############################################################################
# Virtual Server Variables
##############################################################################

variable security_group_names {
  description = "A list of additional security groups to add to the primary interface of the VSI"
  type        = list(string)
  default     = []
}

variable image_name {
  description = "The image name to be used for the bastion host. Use `ibmcloud is images` to list image names."
  type        = string
  default     = "ibm-centos-7-9-minimal-amd64-4"
}

variable profile {
  description = "The profile to be used for the bastion host"
  type        = string
  default     = "bx2-8x32"
}

##############################################################################