variable compartment_ocid { default = "define your target compartment id" }
variable region { default = "define your target region, for example us-ashburn-1" }
variable tenancy_ocid {default = "define the ocid of the tenancy"}
variable ocir_user_name { default = "define the username for the OCIR repos"}
variable ocir_user_password {
    default = "password for OCIR repos"
    sensitive = true
    }


variable application_name {
  default = "cloudnative-2021App"
}

variable "function_name" {
  default = "my-new-function"
}

variable "test_invoke_function_body"  {
  default = "{\"name\": \"Brave New World\"}"
} 

# OCIR repo name & namespace

locals {
  app_name_lower = lower(var.application_name)
  ocir_repo_name = "cloudnative-2021/functions"  
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key")), ".ocir.io"])
  ocir_namespace         = lookup(data.oci_objectstorage_namespace.os_namespace, "namespace")
}

