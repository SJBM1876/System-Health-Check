# System-Health-Check
PowerShell script to perform health checks on local or remote machines
Define What to Monitor:

🔹 CPU Usage – How much CPU is currently in use.
🔹 Memory Usage – How much RAM is free and used.
🔹 Disk Usage – How much free space is left on the system drive.
🔹 Running Processes – Display top resource-consuming processes.
🔹 System Uptime – How long the system has been running.
🔹 Service Status – Check critical Windows services.

Understanding Key PowerShell Cmdlets:

Get-Process → Lists running processes and their resource usage.
Get-WMIObject Win32_OperatingSystem → Retrieves system information like uptime and memory usage.
Get-PhysicalDisk → Checks disk status and free space.
Get-Service → Checks the status of Windows services.

Explanation of the Code

System Uptime
Uses Get-WMIObject Win32_OperatingSystem to get the last boot time.
Converts the time into a readable format.

CPU Usage
Get-WMIObject Win32_Processor fetches the CPU load percentage.

Memory Usage
Retrieves total and free memory, then calculates used memory.
Converts from kilobytes to gigabytes for readability.

Disk Usage
Uses Get-PSDrive to check available disk space on all drives.

Running Processes (Top 5 by CPU)
Get-Process lists running processes.
Sorts them by CPU usage and displays the top 5.

Service Status Check
Monitors the status of critical services (Windows Defender, Windows Update, Print Spooler).
Loops through a predefined list of services and reports their status.

