import subprocess
from .os_detect import IS_WINDOWS


def cpu_info():

    if IS_WINDOWS:
        load = subprocess.getoutput('powershell "Get-CimInstance Win32_Processor | Select-Object LoadPercentage"')
        procs = subprocess.getoutput('powershell "Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 Name, CPU, WorkingSet"')

        return f"""
CPU STATUS (Windows)
--------------------
{load}

TOP CPU PROCESSES
-----------------
{procs}
"""
    else:
        top = subprocess.getoutput("top -b -n1 | head -20")
        ps = subprocess.getoutput("ps aux --sort=-%cpu | head")

        return f"""
CPU STATUS
----------
{top}

TOP CPU PROCESSES
-----------------
{ps}
"""


def memory_info():

    if IS_WINDOWS:
        mem = subprocess.getoutput('powershell "Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory"')
        procs = subprocess.getoutput('powershell "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15 Name, @{N=\'MemMB\';E={[math]::Round($_.WorkingSet/1MB,1)}}"')

        return f"""
MEMORY STATUS (Windows)
-----------------------
{mem}

TOP MEMORY PROCESSES
--------------------
{procs}
"""
    else:
        free = subprocess.getoutput("free -h")
        vm = subprocess.getoutput("vmstat")

        return f"""
MEMORY STATUS
-------------
{free}

VMSTAT
------
{vm}
"""


def disk_info():

    if IS_WINDOWS:
        drives = subprocess.getoutput('powershell "Get-PSDrive -PSProvider FileSystem | Format-Table Name, Used, Free, @{N=\'SizeGB\';E={[math]::Round(($_.Used+$_.Free)/1GB,1)}}"')
        details = subprocess.getoutput('powershell "Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, @{N=\'SizeGB\';E={[math]::Round($_.Size/1GB,1)}}, @{N=\'FreeGB\';E={[math]::Round($_.FreeSpace/1GB,1)}}, FileSystem"')

        return f"""
DISK USAGE (Windows)
--------------------
{drives}

DRIVE DETAILS
-------------
{details}
"""
    else:
        df = subprocess.getoutput("df -h")
        du = subprocess.getoutput("du -sh /* 2>/dev/null")

        return f"""
DISK USAGE
----------
{df}

DIRECTORY SIZE
--------------
{du}
"""


def service_info(service):

    if IS_WINDOWS:
        status = subprocess.getoutput(f'powershell "Get-Service -Name {service} | Format-List Name, Status, StartType, DisplayName"')
        events = subprocess.getoutput(f'powershell "Get-WinEvent -LogName System -FilterXPath \'*[System[Provider[@Name=\\\"{service}\\\"]]]\'  -MaxEvents 10 2>$null | Format-Table TimeCreated, Message -Wrap"')

        return f"""
SERVICE STATUS (Windows)
------------------------
{status}

RECENT EVENTS
-------------
{events}
"""
    else:
        status = subprocess.getoutput(f"systemctl status {service}")
        logs = subprocess.getoutput(f"journalctl -u {service} --no-pager | tail -20")

        return f"""
SERVICE STATUS
--------------
{status}

RECENT LOGS
-----------
{logs}
"""
