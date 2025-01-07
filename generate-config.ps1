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

# Fetch variables from the YAML file
$variables = $librarySets.library_sets
Write-Output "Loaded variables:"
Write-Output ($variables | ConvertTo-Json -Depth 2)

# Initialize a hashtable to store consolidated variables
$consolidatedVars = @{}

# Step 1: Extract environment-specific variables
foreach ($key in $variables.Keys) {
    if ($variables[$key] -is [System.Collections.Hashtable] -and $variables[$key].environments) {
        if ($variables[$key].environments.ContainsKey($environment)) {
            $consolidatedVars[$key] = $variables[$key].environments[$environment].value
        }
    }
}

# Step 2: Add default/global variables
foreach ($key in $variables.Keys) {
    if ($variables[$key] -is [System.Collections.Hashtable] -and $variables[$key].ContainsKey("value") -and -not $variables[$key].ContainsKey("environments")) {
        $consolidatedVars[$key] = $variables[$key].value
    }
}

# Step 3: Exit if no variables were consolidated
if ($consolidatedVars.Count -eq 0) {
    Write-Output "No variables found for environment '$environment'. Exiting."
    exit 1
}

# Step 4: Write the consolidated variables to a PowerShell script
$configFilePath = ".\config.ps1"
Write-Output "Writing consolidated variables to `${configFilePath}`"
$consolidatedVars.GetEnumerator() | ForEach-Object { "`${($_.Key)} = '`${($_.Value)}'" } > $configFilePath

# Output the consolidated variables for debugging
Write-Output "Consolidated variables written to `${configFilePath}`:"
Write-Output ($consolidatedVars | ConvertTo-Json -Depth 2)
