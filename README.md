---
page_type: sample
languages:
  - bicep
name: Azure Copilot-JSK
description: Deployment of Azure Copilot-JSK Sandbox
products:
  - azure
urlFragment:
---

# Azure Copilot Jump Start Kit (Copilot-JSK)

This repository provides an infrastructure deployment of a sandbox environment of the Azure Copilot Jump Start Kit

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/copilot-jsk/main/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fcopilot-jsk%2Fmain%2Fazuredeploy.json)

## Content

| File/folder       | Description                                |
| ----------------- | ------------------------------------------ |
| `modules`         | Bicep Module Directory                     |
| `.gitignore`      | Define what to ignore at commit time.      |
| `README.md`       | This README file.                          |
| `LICENSE.md`      | The license for the sample.                |

### Prerequisites

- Azure CLI: [Download](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli#install-or-update)
- Azure PowerShell: [Download](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-7.1.0)
- An Azure Subscription: [Free Account](https://azure.microsoft.com/en-gb/free/search/)
- Visual Studio Code: [Download](https://code.visualstudio.com/Download)
  - Bicep Extension: [Download](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

### Quickstart

### Part 0 - Get the repository

In this part, we are going to get a local copy of the lab files for use in the rest of the lab.

1. Create a new root folder for the repository in a location of your choice.
2. Open a terminal and navigate to the new folder.
3. Run `git clone https://github.com/Azure/copilot-jsk` to clone the repository into the new folder; they will be in a subfolder called `copilot-jsk`.

### Deploying Azure Copilot and dependent resources

#### Architecture

#### Description

This architecture deploys the following:

#### dependencies/ai-resource.bicep

Containing:

- Azure AI Hub
- Azure AI Compute Resource
- Azure AI Project(s)

### dependencies/dependent-resource.bicep

Containing:

- Azure Application Insights
- Azure Container Registry
- Azure Key Vault
- Storage Account

## Deployment

:hourglass_flowing_sand: **Average Solution End to End Deployment time**: 10 minutes

- Open a Visual Studio Code session, clone the repository and then open up a VS Code session in the folder for the cloned repo.

:warning: Ensure you are logged into Azure using the Azure CLI.

```shell
az login
az account set --subscription '<<your subscription name>>'
```

### Method (1) - `main.bicep` file

- Deploy the [main.bicep](main.bicep) by modifying the `identifier` parameter to something that is unique to your deployment (i.e. a 5 letter string). Additionally you can also change the `location` parameter to a different Azure region of your choice.

```powershell
az deployment sub create --location 'westus' --name 'ai-demo' --template-file '<<path to the repo>>/modules/main.bicep' --verbose
```

### Method (2) - `azure.deployment.parameters.json` file

- Deploy the [main.parameters.json](main.parameters.json) by modifying the `identifier` parameter to something that is unique to your deployment (i.e. a 5 letter string). Additionally you can also change the `location` parameter to a different Azure region of your choice.

```powershell
az deployment sub create --location 'westus' --name 'ai-demo' --template-file '<<path to the repo>>/modules/main.bicep' --parameters 'azure.deployment.parameters.json' --verbose
```

---

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
