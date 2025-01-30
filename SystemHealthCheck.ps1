# System Health Check Script

Write-Output "================= System Health Check Report ================="

# 1. Check System Uptime
$uptime = (Get-WmiObject Win32_OperatingSystem).LastBootUpTime
$uptimeFormatted = [System.Management.ManagementDateTimeConverter]::ToDateTime($uptime)
Write-Output "`nSystem Uptime: $uptimeFormatted (Last Reboot Time)"

# 2. Check CPU Usage
$cpuLoad = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty LoadPercentage
Write-Output "`nCPU Usage: $cpuLoad%"

# 3. Check Memory Usage
$os = Get-CimInstance Win32_OperatingSystem
$totalMemory = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeMemory = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedMemory = $totalMemory - $freeMemory
Write-Output "`nMemory Usage:"
Write-Output "  Total Memory: $totalMemory GB"
Write-Output "  Used Memory: $usedMemory GB"
Write-Output "  Free Memory: $freeMemory GB"

# 4. Check Disk Space (all drives)
Write-Output "`nDisk Usage:"
Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
    $drive = $_
    $totalSpace = [math]::Round($drive.Used + $drive.Free, 2)
    $freeSpace = [math]::Round($drive.Free, 2)
    $usedSpace = [math]::Round($totalSpace - $freeSpace, 2)
    $usedPercentage = [math]::Round(($usedSpace / $totalSpace) * 100, 2)

    Write-Output " $($drive.Name) Drive:"
    Write-Output "  Total Space: $totalDisk GB"
    Write-Output "  Used Space: $usedSpace GB ($usedPercentage%)"
    Write-Output "  Free Space: $freeDisk GB"
}

# 5. Check Running Processes (Top 5 by CPU usage)
Write-Output "`nTop 5 CPU-Consuming Processes:(as of $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss'))"
Get-Process |
        Sort-Object CPU -Descending |
        Select-Object -First 5 |
        Format-Table -AutoSize Name, ID,
        @{Name="Memory (MB)"; Expression={[math]::Round(($_.WorkingSet64 / 1MB), 2)}}

# 6. Check Critical Windows Services
$services = @("WinDefend", "wuauserv", "Spooler")  # Example: Windows Defender, Windows Update, Print Spooler
Write-Output "`nChecking Important Services:"
foreach ($service in $services) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status) {
        Write-Output "  $($status.Name) is $($status.Status)"
    } else {
        Write-Output "  Service $service not found!"
    }
}

Write-Output "`n============================================================="
Write-Output "System Health Check Completed!"
Read-Host "Press Enter to Exit"
