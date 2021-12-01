## DEVOPS -
## NOTE: the policies shown here are defined far too wide for a serious environment
resource "oci_identity_dynamic_group" "devops_deployment_pipeline_dg" {
  compartment_id = var.tenancy_ocid
  name           = "${var.app_name}-devops-deployment-pipeline-dg"
  description    = "${var.app_name} DevOps Deployment Pipeline Dynamic Group"
  matching_rule  = "All {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_dynamic_group" "devops_build_pipeline_dg" {
  compartment_id = var.tenancy_ocid
  name           = "${var.app_name}-devops_build_pipeline_dg"
  description    = "${var.app_name} DevOps Build Pipeline Dynamic Group"
  matching_rule  = "All {resource.type = 'devopsbuildpipeline', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "devops_compartment_policies" {
  depends_on  = [oci_identity_dynamic_group.devops_deployment_pipeline_dg]
  name        = "${var.app_name}-devops-compartment-policies"
  description = "${var.app_name} DevOps Compartment Policies"
  compartment_id = var.tenancy_ocid
  statements     = local.allow_devops_manage_compartment_statements
}



resource "oci_identity_policy" "devops_buildpipeline-dg_policies" {
  depends_on  = [oci_identity_dynamic_group.devops_build_pipeline_dg]
  name        = "${var.app_name}-devops_build_pipeline-dg_policies"
  description = "${var.app_name} DevOps Build Pipeline Policies"
  compartment_id = var.tenancy_ocid
  ## Provide access to read deployment artifacts in the Deliver Artifacts stage, read DevOps code repository in the Build stage, and trigger deployment pipeline in the Trigger Deploy stage
  ## To deliver artifacts, provide access to the Artifact Registry
  ## To deliver artifacts, provide access to the Container Registry (OCIR):
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.devops_buildpipeline_dg.name} to manage devops-family in compartment id ${var.compartment_ocid}"
  , "Allow dynamic-group ${oci_identity_dynamic_group.devops_buildpipeline_dg.name} to manage generic-artifacts in compartment id ${var.compartment_ocid}"
  , "Allow dynamic-group ${oci_identity_dynamic_group.devops_buildpipeline_dg.name} to manage repos in compartment id ${var.compartment_ocid}"
  , "Allow dynamic-group ${oci_identity_dynamic_group.devops_buildpipeline_dg.name} to manage functions-family in compartment id ${var.compartment_ocid}"
  ]
}



locals {
  devops_pipln_dg = oci_identity_dynamic_group.devops_deployment_pipeline_dg.name
  allow_devops_manage_compartment_statements = [
    "Allow dynamic-group ${local.devops_pipln_dg} to manage all-resources in compartment id ${var.compartment_ocid}"
  ]
}

