param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Load and parse the YAML file
$yamlPath = ".\library-variables.yml"
$yamlContent = Get-Content -Raw -Path $yamlPath
$variables = (ConvertFrom-Yaml $yamlContent).library_sets

# Consolidate environment-specific and global variables
$consolidatedVars = @{}
foreach ($key in $variables.Keys) {
    $value = $null
    if ($variables[$key] -is [System.Collections.Hashtable]) {
        if ($variables[$key].ContainsKey("environments") -and $variables[$key].environments.ContainsKey($environment)) {
            $value = $variables[$key].environments[$environment]["value"]
        } elseif ($variables[$key].ContainsKey("value") -and -not $variables[$key].ContainsKey("environments")) {
            $value = $variables[$key]["value"]
        }
    }
    if (![string]::IsNullOrWhiteSpace($key) -and (![string]::IsNullOrWhiteSpace($value))) {
        $consolidatedVars[$key] = $value
    }
}

# Exit if no variables were consolidated
if ($consolidatedVars.Count -eq 0) {
    Write-Output "No variables found for environment '$environment'. Exiting."
    exit 1
}

# Write the consolidated variables to a PowerShell script
$configFilePath = ".\config.ps1"
$consolidatedVars.GetEnumerator() | ForEach-Object {
    $key = $_.Key
    $value = $_.Value
    if (![string]::IsNullOrWhiteSpace($key) -and (![string]::IsNullOrWhiteSpace($value))) {
        "Set-Variable -Name '${key}' -Value '${value}'"
    } else {
        Write-Output "Skipping invalid entry: Key='${key}', Value='${value}'"
    }
} | Out-File -FilePath $configFilePath -Encoding UTF8

Write-Output "Variables successfully written to ${configFilePath}."

