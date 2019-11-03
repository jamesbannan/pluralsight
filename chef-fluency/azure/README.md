# Deploy and register Azure VMs against Hosted Chef

This folder contains the assets needed to deploy a simple Azure IaaS solution using Terraform and register the VMs against the hosted instance of [Chef Infra Server](https://manage.chef.io).

The solution deploys:

- 2 x Ubuntu virtual machines (including VM extensions)
- 1 x Key Vault (for storing the generated VM admin password)
- Azure Bastion for secure SSH access to the VMs
- Virtual Network with subnets and NSG

## Requirements

The solution assumes that you are running a system with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed on Bash (e.g. Ubuntu, MacOS or Windows Subsystem for Linux on Windows 10). You should also have authenticated against an Azure environment using `az login` with credentials which has  Owner permissions at the subscription scope. The environment also requires the latest build [Hashicorp Terraform](https://www.terraform.io/) - the demo was built and tested using Terraform v0.12.13.

Because the VMs make use of the Azure VM extension for Chef on Linux, you will need:

- To have registered with Hosted Chef
- Downloaded the organization validation key (Administration --> Reset Validation Key) to the local system

Then, in order for the deployment to run successfully, populate the following Terraform variables in the [vars.tf](terraform/vars.tf) file:

- chef_validation_key_path
- chef_server_url
- chef_validation_client_name

Terraform will read the contents of the organization validator key and pass it to the Azure VM extension resources.