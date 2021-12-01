variable compartment_ocid { default = "define your target compartment id" }
variable region { default = "define your target region, for example us-ashburn-1" }
variable tenancy_ocid {default = "define the ocid of the tenancy"}
variable ocir_user_name { default = "define the username for the OCIR repos"}
variable ocir_user_password {
    default = "password for OCIR repos"
    sensitive = true
    }


# DEVOPS
variable devops_project_name { default = "define the name of the DevOps project"}
variable devops_code_repository_name { default = "define the name of the DevOps Code Repository associated with the Build Pipeline"}


## Function
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
variable "ocir_repo_name" {
  default = "cloudnative-2021/functions"
}


locals {
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key")), ".ocir.io"])
  ocir_namespace         = lookup(data.oci_objectstorage_namespace.os_namespace, "namespace")
}

