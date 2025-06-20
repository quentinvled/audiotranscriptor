REM Author: VLED
REM Date: 2024-01-01


@echo off
REM Version simple et robuste qui fonctionne a coup sur

REM Forcer la fenetre a rester ouverte
if "%1"=="" (
    cmd /k "%~f0" RUN
    exit
)

title Installation VLED Transcriptor
color 0B
cls
cls

echo ====================================
echo   VLED TRANSCRIPTOR - INSTALLATION
echo ====================================
echo.

REM Aller dans le bon dossier
cd /d "%~dp0"

REM ETAPE 1 - Verifier Python
echo [1] Verification de Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo Python n'est pas installe !
    echo.
    echo Telecharger Python ici :
    echo https://www.python.org/downloads/
    echo.
    echo Puis relancez ce script
    echo.
    pause
    exit
)
echo     Python OK
echo.

REM ETAPE 2 - Creer les dossiers
echo [2] Creation des dossiers...
if not exist config mkdir config
if not exist exports mkdir exports
if not exist temp mkdir temp
echo     Dossiers OK
echo.

REM ETAPE 3 - Installer les modules
echo [3] Installation des modules Python...
echo     (Cela peut prendre 5 minutes)
echo.

python -m pip install --upgrade pip
python -m pip install streamlit
python -m pip install openai
python -m pip install python-dotenv
python -m pip install psutil

echo.
echo     Modules OK
echo.

REM ETAPE 4 - Creer le lanceur
echo [4] Creation du lanceur...
(
echo @echo off
echo cd /d "%%~dp0"
echo python -m streamlit run transcripteur_pro.py
echo pause
) > LANCER.bat

echo     Lanceur OK
echo.

REM ETAPE 5 - Creer le configurateur
echo [5] Creation du configurateur API...
(
echo @echo off
echo cls
echo echo Configuration de la cle API OpenAI
echo echo ==================================
echo echo.
echo set /p KEY=Entrez votre cle API : 
echo echo OPENAI_API_KEY=%%KEY%%^> config\api_key.env
echo echo.
echo echo Cle sauvegardee !
echo pause
) > CONFIG_API.bat

echo     Configurateur OK
echo.

echo ====================================
echo    INSTALLATION TERMINEE !
echo ====================================
echo.
echo Prochaines etapes :
echo.
echo 1. Lancez CONFIG_API.bat
echo 2. Entrez votre cle OpenAI
echo 3. Lancez LANCER.bat
echo.
echo ====================================
echo.
pause