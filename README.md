# Video Hearings Azure DevOps Agent

This repository contain the pipeline and terraform code to deploy Azure DevOps Agents for the use of the Video Hearings project.

As the agents are generically used across all environments they are deployed and hosted within the `DTS-SHAREDSERVICES-STG` subscription.

## Agent Count
You can amend how many agents will be deployed on each VM by editing the variable `agentCount` in the file `pipeline\variables\common.yaml`

## Virtual Machine Count
You can amend how many Virtual Machines will be deployed by editing the variable `agentCount` in the file `pipeline\variables\common.yaml`