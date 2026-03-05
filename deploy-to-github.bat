@echo off
cd /d %~dp0
git add .
git commit -m "Initial commit: SuperChat v1.0.0"
git push -u origin main
pause
