from rich import print
from .provider_router import query_model
from .utils import run_shell_command
from .system_inspector import cpu_info, memory_info, disk_info, service_info
from .os_detect import get_system_prompt, get_os_name
import os


def ask_ai(prompt):

    print("[green]AI thinking...[/green]\n")

    response = query_model(get_system_prompt() + prompt)

    print("[cyan]AI Response:[/cyan]\n")
    print(response)


def explain_command(cmd):

    os_name = get_os_name()
    prompt = f"Explain this {os_name} command with example: {cmd}"

    ask_ai(prompt)


def fix_error(error):

    os_name = get_os_name()
    prompt = f"How to fix this {os_name} error:\n{error}"

    ask_ai(prompt)


def fix_command_output(command):

    print(f"[yellow]Running: {command}[/yellow]\n")

    output = run_shell_command(command)

    if not output.strip():
        print("[green]Command ran successfully with no errors.[/green]")
        return

    print(f"[red]Error output:[/red]\n{output}\n")

    prompt = f"I ran this command:\n{command}\n\nAnd got this error:\n{output}\n\nHow to fix it?"

    ask_ai(prompt)


def fix_piped(data):

    os_name = get_os_name()
    prompt = f"How to fix this {os_name} error output:\n{data}"

    ask_ai(prompt)


def generate_command(task):

    os_name = get_os_name()
    prompt = f"Generate a {os_name} command for: {task}"

    ask_ai(prompt)


def run_generated_command(task):

    os_name = get_os_name()
    prompt = f"Generate only the {os_name} command for: {task}"

    command = query_model(get_system_prompt() + prompt)

    print("\nSuggested command:\n")
    print(command)

    confirm = input("\nRun command? (y/n): ")

    if confirm.lower() == "y":

        output = run_shell_command(command)

        print("\nOutput:\n")
        print(output)


def analyze_log(path):

    if not os.path.exists(path):
        print(f"[red]Error:[/red] The file '{path}' does not exist.")
        return
        
    if not os.path.isfile(path):
        print(f"[red]Error:[/red] '{path}' is a directory or special file, not a readable log file.")
        return

    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            data = f.read()[-4000:]
            
        if not data.strip():
            print(f"[yellow]Warning:[/yellow] The file '{path}' is empty.")
            return

        prompt = f"Analyze this log and suggest fix:\n{data}"

        ask_ai(prompt)
        
    except Exception as e:
        print(f"[red]Error reading file:[/red] {str(e)}")


def diagnose_cpu():

    data = cpu_info()

    prompt = f"Analyze CPU usage and suggest fixes:\n{data}"

    ask_ai(prompt)


def diagnose_memory():

    data = memory_info()

    prompt = f"Analyze memory usage and suggest fixes:\n{data}"

    ask_ai(prompt)


def diagnose_disk():

    data = disk_info()

    prompt = f"Analyze disk usage and suggest fixes:\n{data}"

    ask_ai(prompt)


def diagnose_service(service):

    data = service_info(service)

    prompt = f"Analyze service issue and suggest fixes:\n{data}"

    ask_ai(prompt)
