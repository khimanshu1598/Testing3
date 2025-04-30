param(
    [Parameter(Mandatory = $true)]
    [string]$DeployReportPath
)

$NoChangesReport = '<?xml version="1.0" encoding="utf-8"?><DeploymentReport xmlns="http://schemas.microsoft.com/sqlserver/dac/DeployReport/2012/02"><Alerts /></DeploymentReport>'

if (-not (Test-Path $DeployReportPath)) {
    Write-Output "ERROR: Deploy report file not found at: $DeployReportPath"
    exit 1
}

$deployReportContent = Get-Content $DeployReportPath -Raw

if ($deployReportContent -eq $NoChangesReport) {
    Write-Output "No change detected in database. Deploy report matches baseline."
    exit 0
} else {
    Write-Output "Change detected in database! Deploy report differs from baseline."
    exit 1
}
