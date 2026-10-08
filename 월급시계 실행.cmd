@echo off
chcp 65001 >nul
start "Salary Clock" powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0salary-clock-app.ps1"
