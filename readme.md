This repository contains OCI Terraform Composites - Terraform plans for the creation of what I call OCI Composites – combinations of resources that will frequently be used together and that will have to be created through Infrastructure as Code. 

The OCI Provider for Terraform allows us to create OCI Resources from Terraform plans. The documentation for the provider illustrates the individual resources. However, frequently specific combinations of resources will be created together as they really make sense together, as composite. That is where this repository will provide ready to use examples of Terraform resource definitions.

The repo contains two composites at present:
* create and invoke a function - including a Container Repository in OCI Container Image Registry, a container image and the Function itself as well as a function call from Terraform
* DevOps Build and Deploy Pipelines for creating a Function - including build specifications, trigger from build to deployment pipeline, IAM dynamic groups and policies for the pipelines and a trigger of the build pipeline from Terraform