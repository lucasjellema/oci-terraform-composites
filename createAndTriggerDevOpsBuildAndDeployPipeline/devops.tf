## Deployment Pipeline
## inspired by https://github.com/oracle-quickstart/oci-arch-devops/tree/master/devops_function



### this resource represents a trial run of deployment pipeline 
#resource "oci_devops_deployment" "trigger_deployment_pipeline_for_new-function" {
#  depends_on         = [oci_devops_deploy_stage.cloudnative2021_new-function_deploy_stage]
#  deploy_pipeline_id = oci_devops_deploy_pipeline.cloudnative2021_new-function_deploy_pipeline.id
#  deployment_type    = "PIPELINE_DEPLOYMENT"
#  display_name       = "${var.application_name}_new-function_${random_string.deploy_id.result}_devops_deployment"
# }

resource "oci_devops_build_run" "trigger_build_pipeline_for_new-function" {
  depends_on         = [oci_devops_deploy_stage.cloudnative2021_new-function_deploy_stage, oci_devops_build_pipeline_stage.build-stage-smoketest-new-app-function-container-image]
  build_pipeline_id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
  build_run_arguments {
        items {
            name = "imageVersion"
            value = "0.0.4"
        }
    }
  display_name       = "Trial run of build pipeline - from Terraform plan"
}

resource oci_devops_build_pipeline cloudnative2021_buildpipeline_new-app-function {
  description  = ""
  display_name = "build_pipeline-new-app-function"
  freeform_tags = {
  }
  project_id = local.devops_project_id
  build_pipeline_parameters {
        items {
            name = "imageVersion"
            default_value = "0.0.3"
            description = "Version tag for container image to be built"
        }
        items {
            default_value = "${var.compartment_ocid}"
            description   = "OCID of target compartment"
            name          = "compartmentOCID"
    }
    }
}

resource oci_devops_build_pipeline_stage build-stage-new-app-function-container-image {
  build_pipeline_id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
    }
  }
  build_pipeline_stage_type = "BUILD"
  build_source_collection {
    items {
      branch = "main"
      connection_id = "ocid1.devopsconnection.oc1.iad.amaaaaaa6sde7caaujhp3cqqnbk5sxkgufb3ynz6mz6y4gghtmsvz434jhzq"
      connection_type = "GITHUB"
      name            = "primary_source"
      #repository_id   = local.devops_repository_id
      repository_url  = "https://github.com/lucasjellema/oci-terraform-composites"
    }
  }
  build_spec_file = "/createAndTriggerDevOpsBuildAndDeployPipeline/functions/fake-fun/build_spec.yaml"
  description  = ""
  display_name = "build-function-container-image"
  image = "OL7_X86_64_STANDARD_10"
  primary_build_source               = "primary_source"
  stage_execution_timeout_in_seconds = "36000"
}


resource oci_devops_build_pipeline_stage build-stage-push-function-container-image-to-registry {
  build_pipeline_id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.build-stage-new-app-function-container-image.id
    }
  }
  build_pipeline_stage_type = "DELIVER_ARTIFACT"

  deliver_artifact_collection {
    items {
      artifact_id   = oci_devops_deploy_artifact.cloudnative2021_new_fun_deploy_ocir_artifact.id
      artifact_name = "output01"
    }
  }  
  description  = "Push the resulting container image for  new function to Container Registry"
  display_name = "push-function-container-image-to-registry"
}


resource oci_devops_build_pipeline_stage build-stage_trigger-new-app-function-deployment-pipeline {
  build_pipeline_id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.build-stage-push-function-container-image-to-registry.id
    }
  }
  build_pipeline_stage_type = "TRIGGER_DEPLOYMENT_PIPELINE"
  deploy_pipeline_id = oci_devops_deploy_pipeline.cloudnative2021_new-function_deploy_pipeline.id
  description        = "Trigger Deployment Pipeline for Nw Function"
  display_name       = "trigger-new-app-function-deployment-pipeline"
  is_pass_all_parameters_enabled = "true"
}

resource oci_devops_build_pipeline_stage build-stage-smoketest-new-app-function-container-image {
  build_pipeline_id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.build-stage_trigger-new-app-function-deployment-pipeline.id
    }
  }
  build_pipeline_stage_type = "BUILD"
  build_source_collection {
    items {
      branch = "main"
      connection_id = "ocid1.devopsconnection.oc1.iad.amaaaaaa6sde7caaujhp3cqqnbk5sxkgufb3ynz6mz6y4gghtmsvz434jhzq"
      connection_type = "GITHUB"
      name            = "primary_source"
      #repository_id   = local.devops_repository_id
      repository_url  = "https://github.com/lucasjellema/oci-terraform-composites"
    }
  }
  build_spec_file = "/createAndTriggerDevOpsBuildAndDeployPipeline/functions/fake-fun/smoke-test/smoke-test-build-spec.yaml"
  description  = ""
  display_name = "perform smoke test"
  image = "OL7_X86_64_STANDARD_10"
  primary_build_source               = "primary_source"
  stage_execution_timeout_in_seconds = "36000"
}



### trigger build pipeline from commit/push in code Repository

resource oci_devops_trigger coderepos_trigger-new-app-function-build {
  actions {
    build_pipeline_id = oci_devops_build_pipeline.cloudnative2021_buildpipeline_new-app-function.id
    filter {
      events = [
        "PUSH",
      ]
      #include = <<Optional value not found in discovery>>
      trigger_source = "DEVOPS_CODE_REPOSITORY"
    }
    type = "TRIGGER_BUILD_PIPELINE"
  }

  description  = ""
  display_name = "trigger-new-app-function-build"

  project_id     = local.devops_project_id
  repository_id  = local.devops_repository_id
  trigger_source = "DEVOPS_CODE_REPOSITORY"
}


### DEPLOY

resource "oci_devops_deploy_environment" "cloudnative2021_new-function_environment" {
  display_name            = "${var.application_name}_new-function_devops_environment"
  description             = "${var.application_name}_new-function_devops_environment"
  deploy_environment_type = "FUNCTION"
  project_id              = local.devops_project_id
  function_id             = local.function_id
}

resource "oci_devops_deploy_artifact" "cloudnative2021_new_fun_deploy_ocir_artifact" {
  project_id                 = local.devops_project_id
  deploy_artifact_type       = "DOCKER_IMAGE"
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_source {
    deploy_artifact_source_type = "OCIR"
    image_uri                   = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${var.function_name}:$${imageVersion}"
  }
}

resource "oci_devops_deploy_pipeline" "cloudnative2021_new-function_deploy_pipeline" {
  project_id   = local.devops_project_id
  description  = "${var.application_name}_new-function_devops_pipeline"
  display_name = "${var.application_name}_new-function_devops_deploy_pipeline"

  deploy_pipeline_parameters {
    items {
      name = "imageVersion"
      default_value = "0.0.1"
      description = "Version tag for container image to be built"
    }
  }
}

resource "oci_devops_deploy_stage" "cloudnative2021_new-function_deploy_stage" {
  deploy_pipeline_id = oci_devops_deploy_pipeline.cloudnative2021_new-function_deploy_pipeline.id
  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.cloudnative2021_new-function_deploy_pipeline.id
    }
  }
  deploy_stage_type = "DEPLOY_FUNCTION"


  description  = "${var.application_name}_new-function_devops_deploy_stage"
  display_name = "${var.application_name}_new-function_devops_deploy_stage"

  namespace                       = "default"
  function_deploy_environment_id  = oci_devops_deploy_environment.cloudnative2021_new-function_environment.id
  docker_image_deploy_artifact_id = oci_devops_deploy_artifact.cloudnative2021_new_fun_deploy_ocir_artifact.id
}

