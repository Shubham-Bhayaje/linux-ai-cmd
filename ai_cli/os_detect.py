import platform

OS_NAME = platform.system()  # "Windows" or "Linux"

IS_WINDOWS = OS_NAME == "Windows"
IS_LINUX = OS_NAME == "Linux"


def get_os_name():
    return OS_NAME


def get_system_prompt():
    if IS_WINDOWS:
        return (
            "You are a Windows system administration expert. "
            "Always give Windows-specific answers using PowerShell or cmd commands. "
            "Use tools like Get-Process, Get-Service, Get-EventLog, wmic, netstat, etc. "
            "Never suggest Linux/bash commands. "
            "Be concise and practical.\n\n"
        )
    else:
        return (
            "You are a Linux system administration expert. "
            "Always give Linux-specific answers using terminal commands. "
            "Use tools like bash, apt, systemctl, grep, awk, sed, etc. "
            "Never suggest GUI or Windows solutions. "
            "Be concise and practical.\n\n"
        )
