terraform {
  required_version = ">= 0.14"
  required_providers {
#  based on https://github.com/oracle-quickstart/oci-arch-devops/blob/master/devops_function/providers.tf
    tls = {
      source  = "hashicorp/tls"
      version = "2.0.1" # Latest version as March 2021 = 3.1.0. Using 2.0.1 (April, 2020) for ORM compatibility
    }
    local = {
      source  = "hashicorp/local"
      version = "1.4.0" # Latest version as March 2021 = 2.1.0. Using 1.4.0 (September, 2019) for ORM compatibility
    }
    random = {
      source  = "hashicorp/random"
      version = "2.3.0" # Latest version as March 2021 = 3.1.0. Using 2.3.0 (July, 2020) for ORM compatibility
    }
  }
}

provider oci {
   region = var.region
}