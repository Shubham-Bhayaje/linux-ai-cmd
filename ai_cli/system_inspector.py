import subprocess


def cpu_info():

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
