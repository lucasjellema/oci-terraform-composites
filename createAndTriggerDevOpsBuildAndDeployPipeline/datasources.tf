# functions 

data "oci_functions_applications" "function_applications" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.application_name}"
}

locals {
  application_id = data.oci_functions_applications.function_applications.applications[0].id
}


# devops

data "oci_devops_projects" "current_devops_projects" {
    compartment_id = var.compartment_ocid
    name = "${var.devops_project_name}" 
}

data "oci_devops_repositories" "project_repositories" {
    compartment_id = var.compartment_ocid
    name = "${var.devops_code_repository_name}"
}



locals {
  devops_project_id = data.oci_devops_projects.current_devops_projects.project_collection[0].items[0].id
  devops_repository_id = data.oci_devops_repositories.project_repositories.repository_collection[0].items[0].id
  devops_repository_url = data.oci_devops_repositories.project_repositories.repository_collection
}

output "devops_project_id" {
  value = "${local.devops_project_id}"
}

output "devops_repo_id" {
  value = "${local.devops_repository_id}"
}

output "fn_application_id" {
  value = "${local.application_id}"
}


# Gets home and current regions
data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}

data "oci_identity_regions" "oci_regions" {

  filter {
    name   = "name"
    values = [var.region]
  }

}

data "oci_identity_tenancy" "oci_tenancy" {
 # tenancy_id = var.tenancy_ocid
}

data "oci_objectstorage_namespace" "os_namespace" {
  compartment_id = var.tenancy_ocid
}

output "tenancy"  {
  value = data.oci_identity_tenancy.oci_tenancy
}


# Randoms
resource "random_string" "deploy_id" {
  length  = 4
  special = false
}