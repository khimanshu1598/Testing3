Write-Output "Running Script 2"

# Perform a sample operation
Write-Output "Performing a sample operation: Calculating the length of the CellName"
$cellNameLength = $CellName.Length
Write-Output "The length of the CellName '$CellName' is: $cellNameLength"

# Create a greeting message
Write-Output "Creating a greeting message using DefaultVar and CellName"
$greetingMessage = "Hello $CellName, have a $DefaultVar day!"
Write-Output $greetingMessage

# Check AnotherVar for conditional logic
Write-Output "Checking AnotherVar for conditional logic"
if ($AnotherVar -eq "another-value-00") {
    Write-Output "AnotherVar matches 'another-value-00'. Taking action..."
    Start-Sleep -Seconds 1
    Write-Output "Action completed for AnotherVar = $AnotherVar"
} else {
    Write-Output "AnotherVar does not match 'another-value-00'. Skipping action."
}
