data "oci_functions_applications" "function_applications" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}"
}

locals {
  application_id = data oci_functions_applications.function_applications[0].id
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


data "oci_identity_tenancy" "oci_tenancy" {
  tenancy_id = var.tenancy_ocid
}

# OCI Services
## Available Services
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_identity_regions" "oci_regions" {

  filter {
    name   = "name"
    values = [var.region]
  }

}

# Randoms
resource "random_string" "deploy_id" {
  length  = 4
  special = false
}