# Video Hearings Azure DevOps Agent

This repository contains Pipelines, Terraform & Packer Code which creates Self Hosted Azure DevOps Agents on Virtual Machine Scale Sets for the Video Hearings Project.

As the agents are used across all environments they are deployed and hosted within the `DTS-SHAREDSERVICES-STG` subscription.

The Virtual Machine Scale Set is configured to pull the latest version Image in Azure Compute Gallery, a new image is generated once a month via the [azure-pipelines.image-build.yml](https://github.com/hmcts/vh-azure-devops-agent/tree/master/pipeline/build/azure-pipelines.image-build.yaml) pipeline to ensure the OS is always up to date with the latest security patches.

## How To Use This Repository

### First Time Use

NOTE: This section is ONLY if you are creating everything from scratch, in the unlikely event of this, please do the following:

1. Run the following Pipeline **/pipeline/build/azure-pipelines.image-build.yml** with parameter.runTerraform set to **true**, this will create the Resource Group & Azure Compute Gallery via Terraform, the pipeline will then create a Golden Image using Packer and store the image in Azure Compute Gallery.

2. Run the following Pipeline **/pipeline/build/azure-pipelines.yml**, this will then deploy all other infrastructure in the repository, this pipeline must be run after Packer has built and pushed the image to the Azure Computer Gallery otherwise the creation of the Virtual Machine Scale Set will fail.

### Subsequent Use
#### Terraform
Any changes to Terraform code should be raised via a pull request, any pull request which is raised will trigger a pipeline which runs a CI check and runs a Terraform Plan, once this pipeline has run succesfully and the pr has been approved, the pull request can then be merged to master, which will run a pipeline to deploy the Terraform changes.

#### Packer
It is reccomended that before pushing any changes to the Packer directory, all changes are built and tested in a Dev or Sandbox environment from your local machine. Documentation on how to use Packer can be found [here](https://developer.hashicorp.com/packer/plugins/builders/azure/arm).

## Installed Software

For all installed software, please refer to documentation found [here](https://github.com/hmcts/vh-azure-devops-agent/tree/master/packer/linux/ubuntu2204.md).