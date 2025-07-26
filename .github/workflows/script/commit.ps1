# commit.ps1 — Sync GitHub to Azure DevOps

# Get secrets from GitHub environment
$AZUREPAT      = $env:AZUREPAT
$AZUREUSERNAME = $env:AZUREUSERNAME
$AZURE_EMAIL   = $env:AZURE_EMAIL
$AZORG         = $env:AZORG

# Set your Azure DevOps project and repo name
$project = "bmrn"         # Replace with your DevOps project
$repo    = "bmrn"    # Replace with your Azure DevOps repo

# Construct the remote URL
$remoteUrl = "https://${AZUREUSERNAME}:${AZUREPAT}@dev.azure.com/${AZORG}/${project}/_git/${repo}"

# Set Git config
git config user.email "$AZURE_EMAIL"
git config user.name "$AZUREUSERNAME"

# Init Git if needed
if (-not (Test-Path ".git")) {
    git init
}

# Set up remote
if (git remote get-url azure 2>$null) {
    git remote remove azure
}
git remote add azure $remoteUrl

# Pull latest
try {
    git fetch azure
    git pull azure main --allow-unrelated-histories
} catch {
    Write-Host "Pull failed (might be first sync) — continuing"
}

# Push changes
git add .
git commit -m "Sync from GitHub to Azure DevOps" --allow-empty
git push azure HEAD:main --force
