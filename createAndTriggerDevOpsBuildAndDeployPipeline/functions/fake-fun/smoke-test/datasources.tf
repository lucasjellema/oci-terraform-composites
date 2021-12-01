# Gets home and current regions
data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid
}

#data "oci_identity_regions" "home_region" {
#  filter {
#    name   = "key"
#    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
#  }
# }

output "tenancy_ocid" {
  value = var.tenancy_ocid
}
output "tenancy_details" {
  value = data.oci_identity_tenancy.tenant_details
}

data "oci_identity_tenancy" "oci_tenancy" {
  tenancy_id = var.tenancy_ocid
}



