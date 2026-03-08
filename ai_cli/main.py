import sys
import typer
from .commands import *

app = typer.Typer()


@app.command(help="Ask AI anything about Linux")
def ask(prompt: str):
    ask_ai(prompt)


@app.command(help="Explain a Linux command")
def explain(cmd: str):
    explain_command(cmd)


@app.command(help="Fix an error (text or piped: cmd 2>&1 | ai fix -)")
def fix(error: str):
    if error == "-":
        data = sys.stdin.read()
        if not data.strip():
            print("[red]No input received from pipe.[/red]")
            return
        fix_piped(data)
    else:
        fix_error(error)


@app.command(help="Run a command, capture errors, and ask AI to fix")
def fixcmd(command: str):
    fix_command_output(command)


@app.command(help="Generate a Linux command for a task")
def cmd(task: str):
    generate_command(task)


@app.command(help="Generate and optionally run a command")
def run(task: str):
    run_generated_command(task)


@app.command(help="Analyze a log file for issues")
def analyze(logfile: str):
    analyze_log(logfile)


@app.command(help="Diagnose CPU usage")
def cpu():
    diagnose_cpu()


@app.command(help="Diagnose memory usage")
def memory():
    diagnose_memory()


@app.command(help="Diagnose disk usage")
def disk():
    diagnose_disk()


@app.command(help="Diagnose a systemd service")
def service(name: str):
    diagnose_service(name)


if __name__ == "__main__":
    app()
