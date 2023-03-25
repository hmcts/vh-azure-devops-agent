# Video Hearings Azure DevOps Agent

This repository contains Pipelines and Terraform Code which creates Self Hosted Azure DevOps Agents on Virtual Machine Scale Sets for the Video Hearings Project.

As the agents are used across all environments they are deployed and hosted within the `DTS-SHAREDSERVICES-STG` subscription.

The Virtual Machine Scale Set is configured to pull the latest 'devops-ubuntu' Image from Azure Compute Gallery 'hmcts'.

## Terraform
Any changes to Terraform code should be raised via a pull request, any pull request which is raised will trigger a pipeline which runs a CI checks and Terraform Plan, once this pipeline has run succesfully and the pr has been approved, the pull request can then be merged to master, which will run trigger a pipeline to deploy the Terraform changes.