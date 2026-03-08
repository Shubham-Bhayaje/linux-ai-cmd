@echo off
echo =========================================
echo  Installing AI CLI (Windows)
echo =========================================
echo.

:: Check for Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python 3.8+ from https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

echo [1/4] Installing Python dependencies...
pip install requests rich typer >nul 2>&1
if errorlevel 1 (
    pip install --user requests rich typer >nul 2>&1
)
echo       Done.

echo [2/4] Cloning the repository...
set INSTALL_DIR=%USERPROFILE%\ai-cli
if exist "%INSTALL_DIR%" (
    echo       Updating existing installation...
    cd /d "%INSTALL_DIR%"
    git pull >nul 2>&1
) else (
    git clone https://github.com/Shubham-Bhayaje/linux-ai-cmd.git "%INSTALL_DIR%" >nul 2>&1
)

echo [3/4] Setting up configuration...
set CONFIG_DIR=%USERPROFILE%\.ai-cli
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

if not exist "%CONFIG_DIR%\config.py" (
    echo.
    echo =========================================
    echo    AI CLI — Setup Wizard
    echo =========================================
    echo.
    echo Choose your AI provider:
    echo   1^) Ollama   — FREE, runs locally (needs 4GB+ RAM^)
    echo   2^) OpenAI   — GPT-4o-mini (needs API key^)
    echo   3^) Claude   — Claude 3 Haiku (needs API key^)
    echo.
    set /p CHOICE="Select provider [1/2/3] (default: 1): "
    if "%CHOICE%"=="" set CHOICE=1

    if "%CHOICE%"=="2" (
        set /p OPENAI_KEY="Enter your OpenAI API key: "
        (
            echo PROVIDER = "openai"
            echo MODEL = "gpt-4o-mini"
            echo.
            echo OLLAMA_URL = "http://localhost:11434/api/generate"
            echo.
            echo OPENAI_API_KEY = "%OPENAI_KEY%"
            echo CLAUDE_API_KEY = ""
        ) > "%CONFIG_DIR%\config.py"
        echo OpenAI configured!
    ) else if "%CHOICE%"=="3" (
        set /p CLAUDE_KEY="Enter your Claude API key: "
        (
            echo PROVIDER = "claude"
            echo MODEL = "claude-3-haiku-20240307"
            echo.
            echo OLLAMA_URL = "http://localhost:11434/api/generate"
            echo.
            echo OPENAI_API_KEY = ""
            echo CLAUDE_API_KEY = "%CLAUDE_KEY%"
        ) > "%CONFIG_DIR%\config.py"
        echo Claude configured!
    ) else (
        (
            echo PROVIDER = "ollama"
            echo MODEL = "phi3"
            echo.
            echo OLLAMA_URL = "http://localhost:11434/api/generate"
            echo.
            echo OPENAI_API_KEY = ""
            echo CLAUDE_API_KEY = ""
        ) > "%CONFIG_DIR%\config.py"
        echo Ollama configured! Make sure Ollama is running: https://ollama.com
    )
)

:: Copy config into the project
copy /Y "%CONFIG_DIR%\config.py" "%INSTALL_DIR%\ai_cli\config.py" >nul 2>&1

echo [4/4] Adding to PATH...

:: Create a wrapper script in a PATH-accessible location
set BIN_DIR=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps
echo @echo off > "%BIN_DIR%\ai.bat"
echo python "%INSTALL_DIR%\ai" %%* >> "%BIN_DIR%\ai.bat"

echo.
echo =========================================
echo  Install Complete! Run: ai --help
echo =========================================
echo.
echo  Open a NEW terminal and type: ai ask "hello"
echo.

pause
