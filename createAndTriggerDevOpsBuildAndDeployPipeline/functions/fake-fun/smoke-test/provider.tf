terraform {
  required_version = ">= 0.14"
}

provider "oci" {
   auth = "InstancePrincipal"
   region = "${var.region}"
}