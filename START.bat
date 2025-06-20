@echo off
title Vled Transcriptor
cd /d "%~dp0"
cls

echo ====================================
echo    VLED TRANSCRIPTOR - DEMARRAGE
echo ====================================
echo.

:: IMPORTANT : Entourer le chemin de guillemets pour gérer les espaces
python -m streamlit run "%CD%\transcripteur_pro.py"

pause