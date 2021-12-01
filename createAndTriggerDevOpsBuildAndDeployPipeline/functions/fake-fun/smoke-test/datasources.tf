output "tenancy_ocid" {
  value = var.tenancy_ocid
}
output "tenancy" {
  value = data.oci_identity_tenancy.oci_tenancy
}
data "oci_identity_tenancy" "oci_tenancy" {
  tenancy_id = var.tenancy_ocid
}


data "oci_devops_projects" "current_devops_projects" {
    compartment_id = "ocid1.compartment.oc1..aaaaaaaacsssekayq4d34nl5h3eqs5e6ak3j5s4jhlws6oxf7rr5pxmt3zrq"
 }


locals {
  devops_projects = data.oci_devops_projects.current_devops_projects.project_collection
}

output "devops_project_id" {
  value = "${local.devops_projects}"
}

