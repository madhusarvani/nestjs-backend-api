@echo off
REM PostgreSQL Setup Batch File for Windows
REM Run this file to automatically set up PostgreSQL

cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "setup-postgres.ps1"
pause
