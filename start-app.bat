@echo off
REM NestJS Backend API - Quick Start Script

echo.
echo ====================================================
echo NestJS Backend API - Build and Start
echo ====================================================
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed!
    echo Please download from: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js version:
node --version

echo.
echo ====================================================
echo Building NestJS Application...
echo ====================================================
echo.

call npm run build

if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ====================================================
echo Starting NestJS Application...
echo ====================================================
echo.

call npm start

pause
