# Simulating another script that uses the same variables
Write-Output "Running Script 2"

# Perform an arithmetic operation using a mock variable
Write-Output "Performing a sample operation: Calculating the length of the CellName"
$cellNameLength = $CellName.Length
Write-Output "The length of the CellName '$CellName' is: $cellNameLength"

# String concatenation using variables
Write-Output "Creating a greeting message using DefaultVar and CellName"
$greetingMessage = "Hello $CellName, have a $DefaultVar day!"
Write-Output $greetingMessage

# Check the value of AnotherVar and take an action
Write-Output "Checking AnotherVar for conditional logic"
if ($AnotherVar -eq "another-value-00") {
    Write-Output "AnotherVar matches 'another-value-00'. Taking action..."
    # Simulate some action
    Start-Sleep -Seconds 1
    Write-Output "Action completed for AnotherVar = $AnotherVar"
} else {
    Write-Output "AnotherVar does not match 'another-value-00'. Skipping action."
}
