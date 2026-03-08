import subprocess


def run_shell_command(cmd):

    result = subprocess.run(
        cmd,
        shell=True,
        capture_output=True,
        text=True
    )

    if result.stdout:
        return result.stdout

    return result.stderr
