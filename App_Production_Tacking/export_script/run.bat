@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo [%date% %time%] Avvio Export Production Tracking...
python export_production_tracking.py

if %errorlevel% neq 0 (
    echo [%date% %time%] ERRORE durante l'esportazione. Log: export.log
    pause
) else (
    echo [%date% %time%] Export completato con successo.
    timeout /t 5 /nobreak >nul
)
