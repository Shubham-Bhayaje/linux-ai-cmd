from rich import print
from .provider_router import query_model
from .utils import run_shell_command
from .system_inspector import cpu_info, memory_info, disk_info, service_info


SYSTEM_PROMPT = (
    "You are a Linux system administration expert. "
    "Always give Linux-specific answers using terminal commands. "
    "Use tools like bash, apt, systemctl, grep, awk, sed, etc. "
    "Never suggest GUI or Windows solutions. "
    "Be concise and practical.\n\n"
)


def ask_ai(prompt):

    print("[green]AI thinking...[/green]\n")

    response = query_model(SYSTEM_PROMPT + prompt)

    print("[cyan]AI Response:[/cyan]\n")
    print(response)


def explain_command(cmd):

    prompt = f"Explain this Linux command with example: {cmd}"

    ask_ai(prompt)


def fix_error(error):

    prompt = f"How to fix this Linux error:\n{error}"

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

    prompt = f"How to fix this Linux error output:\n{data}"

    ask_ai(prompt)


def generate_command(task):

    prompt = f"Generate Linux command for: {task}"

    ask_ai(prompt)


def run_generated_command(task):

    prompt = f"Generate only the Linux command for: {task}"

    command = query_model(prompt)

    print("\nSuggested command:\n")
    print(command)

    confirm = input("\nRun command? (y/n): ")

    if confirm.lower() == "y":

        output = run_shell_command(command)

        print("\nOutput:\n")
        print(output)


def analyze_log(path):

    with open(path) as f:
        data = f.read()[-4000:]

    prompt = f"Analyze this Linux log and suggest fix:\n{data}"

    ask_ai(prompt)


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
