These Terraform resources are used to create a new function, deploy the function and invoke it. These plans can be executed most easily in the OCI Cloudshell (where Terraformm, the OCI Provide and the ~/.oci/config file are all available)

The assumptions/prerequisites:
* the target compartment's OCID is specified in variables.tf
* a function application (into which the function is to be created) already exists and its name is defined in variables.tf
* the function's name is defined in variables.tf
* the user applying the Terraform plan has the required permissions to create a function in the compartment, a repository in the container registry and add the function to the application 
