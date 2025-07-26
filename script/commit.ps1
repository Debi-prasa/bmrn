#!/bin/bash


# Assign environment variables to local variables (optional but cleaner)
$AZUREPAT = $env:AZUREPAT
$AZUREUSERNAME = $env:AZUREUSERNAME
$AZURE_EMAIL = $env:AZURE_EMAIL
$AZORG = $env:AZORG


# Remove Git information (for fresh git start)
#rm -rf bmrn/.git


# Fetch the changes from Azure DevOps to ensure we have latest
git fetch --unshallow


# Pull changes from Azure DevOps if its exiting branch and have commits on it
git pull https://debiprasad0828@dev.azure.com/debiprasad0828/bmrn/_git/bmrn


#git checkout -b $github_to_azure_sync


# Set Git user identity
git config --global user.email "$AZURE_EMAIL"
git config --global user.name "$AZUREUSERNAME"


# Add all changes into stage, commit, and push to Azure DevOps
git add .
git commit -m "Sync from GitHub to Azure DevOps"
git push --force https://debiprasad0828@dev.azure.com/debiprasad0828/bmrn/_git/bmrn
