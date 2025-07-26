# commit.ps1 — Sync GitHub to Azure DevOps

# Get secrets from GitHub environment
$AZUREPAT      = $env:AZUREPAT
$AZUREUSERNAME = $env:AZUREUSERNAME
$AZURE_EMAIL   = $env:AZURE_EMAIL
$AZORG         = $env:AZORG

# Set your Azure DevOps project and repo name
$project = "bmrn"         # Replace if different
$repo    = "bmrn"    # ✅ Your actual Azure DevOps repo name

# Construct remote URL with authentication
$remoteUrl = "https://$AZUREUSERNAME:$AZUREPAT@dev.azure.com/$AZORG/$project/_git/$repo"

# Set Git config for commits
git config user.name "$AZUREUSERNAME"
git config user.email "$AZURE_EMAIL"

# Initialize Git if needed
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..."
    git init
}

# Set up Azure DevOps remote
if (git remote get-url azure 2>$null) {
    git remote remove azure
}
git remote add azure $remoteUrl

# Pull latest to avoid history issues
try {
    git fetch azure
    git pull azure main --allow-unrelated-histories
} catch {
    Write-Host "Pull failed — likely first sync. Continuing..."
}

# Stage, commit, and push changes
git add .
git commit -m "Sync from GitHub to Azure DevOps" --allow-empty
git push azure HEAD:main --force