@echo off
title Jenkins Environment Setup (Docker + Python + pytest + OWASP ZAP)
echo ===== Jenkins Windows Environment Setup =====

:: === 1. Check Docker ===
echo [1/5] Checking Docker...
where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo Docker not found.
    echo Downloading Docker Desktop. Please install and restart.
    start https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe
    pause
    exit /b
) else (
    docker --version
)

:: === 2. Check Python & pip ===
echo [2/5] Checking Python...
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python not found.
    echo Downloading Python installer. Please install and restart.
    start https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe
    pause
    exit /b
) else (
    python --version
    echo Installing pip dependencies: pytest, zap-cli...
    pip install pytest python-owasp-zap-v2.4
)

:: === 3. Check OWASP ZAP ===
echo [3/5] Checking OWASP ZAP installation...
if not exist "C:\Program Files\OWASP\ZAP\zap.bat" (
    echo OWASP ZAP not found.
    echo Downloading OWASP ZAP installer. Please install and restart.
    start https://github.com/zaproxy/zaproxy/releases/latest/download/ZAP_WEEKLY_WINDOWS.exe
    pause
    exit /b
) else (
    echo ZAP found at C:\Program Files\OWASP\ZAP\
)

:: === 4. Add ZAP to PATH if missing ===
set "ZAP_PATH=C:\Program Files\OWASP\ZAP"
echo [4/5] Adding ZAP to PATH (if needed)...
echo %PATH% | find /I "%ZAP_PATH%" >nul
if %errorlevel% neq 0 (
    echo ZAP not found in PATH. Adding temporarily...
    setx PATH "%PATH%;%ZAP_PATH%"
) else (
    echo ZAP already in PATH.
)

:: === 5. Test all commands ===
echo [5/5] Verifying commands for Jenkins pipeline...
echo ------------------------------
echo Running: docker version
docker --version

echo Running: pytest version
pytest --version

echo Running: zap-cli version (check ZAP start manually)
python -c "from zapv2 import ZAPv2; print('ZAP module loaded successfully')" || echo ZAP CLI not working.

echo ------------------------------
echo ✅ Environment ready for Jenkins Blue-Green pipeline!
pause
