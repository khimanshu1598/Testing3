param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Path to the library YAML file
$yamlPath = ".\library-variables.yml"

# Load the YAML file
$yamlContent = Get-Content -Raw -Path $yamlPath
$librarySets = $yamlContent | ConvertFrom-Yaml

# Fetch variables for the selected environment
$variables = $librarySets.library_sets
Write-Output "Loaded variables: -"
Write-Output ($variables | ConvertTo-Json -Depth 2)

# Initialize a hashtable to store consolidated variables
$consolidatedVars = @{}

# Search for the environment in all keys dynamically
foreach ($key in $variables.Keys) {
    if ($variables[$key] -is [System.Collections.Hashtable] -and $variables[$key].environments) {
        if ($variables[$key].environments.ContainsKey($environment)) {
            $consolidatedVars[$key] = $variables[$key].environments[$environment].value
        }
    }
}

# Add DefaultVar if it exists
if ($variables.ContainsKey("DefaultVar")) {
    $consolidatedVars["DefaultVar"] = $variables["DefaultVar"].value
}

# Exit if no variables were consolidated
if ($consolidatedVars.Count -eq 0) {
    Write-Output "No variables found for environment '$environment'. Exiting."
    exit 1
}

# Write the consolidated variables to a PowerShell script
$configFilePath = ".\config.ps1"
$consolidatedVars.GetEnumerator() | ForEach-Object { "`${($_.Key)} = '`${($_.Value)}'" } > $configFilePath

Write-Output "Consolidated variables written to $configFilePath"
