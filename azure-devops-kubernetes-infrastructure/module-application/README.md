# Deploy an application to an AKS cluster

This folder contains the assets needed to deploy an application to a pre-existing AKS Cluster in a Microsoft Azure subscription.

The assets are designed to support the module <em>Deploying an Application to AKS</em> in the Pluralsight course <strong>Manage Kubernetes Infrastructure</strong>.

The assets to deploy the application are contained in the [sock-shop](sock-shop) folder. This contains a [Helm](https://helm.sh/) chart of the Sock Shop demo application, which is built and maintained by [Weaveworks](https://microservices-demo.github.io/).

The assets in the [sock-shop](sock-shop) folder are taken almost completely from the [original GitHub repo](https://github.com/microservices-demo/microservices-demo/tree/master/deploy/kubernetes/helm-chart), but are provided in this repository for ease of access.

The Sock Shop application is great for showcasing Kubernetes as it's a multi-tier application with lots of moving parts using a variety of different technologies:

![Architecture diagram](https://github.com/microservices-demo/microservices-demo.github.io/blob/master/assets/Architecture.png "Architecture")

For this demo, the solution is designed to be deployed using [Helm](https://helm.sh/), although you can also deploy directly to an AKS endpoint using [`kubectl`](https://github.com/microservices-demo/microservices-demo/tree/master/deploy/kubernetes).

## Requirements

The solution assumes that you are running a system with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed. You should also have authenticated against an Azure environment using `az login` with credentials which have sufficient permissions in the Azure AD tenant to create new service principals and Owner permissions at the subscription scope. The environment also requires [Hashicorp Terraform](https://www.terraform.io/) - the demo was built and tested using Terraform v0.12.8 - as well as [Helm](https://helm.sh/). The demo was built and tested using [Helm 2.14.3](https://github.com/helm/helm/releases/tag/v2.14.3).
