@echo off
REM Simple PostgreSQL Database Creation Script
REM Just enter your postgres password when prompted

echo.
echo ====================================================
echo PostgreSQL Database Setup
echo ====================================================
echo.
echo This script will create the 'nestjs_api' database
echo.

set /p pgPassword="Enter your PostgreSQL 'postgres' user password: "

echo.
echo Creating database...
echo.

@REM Use psql to create database
psql -U postgres -h localhost -w -c "CREATE DATABASE nestjs_api;" 2>nul

if %errorlevel% equ 0 (
    echo.
    echo SUCCESS! Database 'nestjs_api' created.
    echo.
) else (
    echo.
    echo Database may already exist or PostgreSQL is not running.
    echo.
    echo Please ensure:
    echo 1. PostgreSQL is installed
    echo 2. PostgreSQL service is running
    echo 3. Your password is correct
    echo.
)

echo.
echo ====================================================
echo Now update .env file with:
echo DB_PASSWORD=%pgPassword%
echo ====================================================
echo.

pause
