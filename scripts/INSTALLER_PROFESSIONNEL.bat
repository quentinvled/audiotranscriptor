@echo off
chcp 65001 >nul
cls
color 0B

REM Vérifier les droits administrateur
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin_ok
) else (
    goto :request_admin
)

:request_admin
echo.
echo ██████████████████████████████████████████████████████████
echo █                                                        █
echo █    🔐 DROITS ADMINISTRATEUR REQUIS                     █
echo █                                                        █
echo ██████████████████████████████████████████████████████████
echo.
echo ⚠️  L'installation nécessite des droits administrateur pour :
echo    • Copier les fichiers dans Program Files
echo    • Créer les raccourcis système
echo    • Configurer les associations de fichiers
echo.
echo 🔄 Relancement avec droits administrateur...
echo.
pause

REM Relancer avec droits admin
powershell -Command "Start-Process '%~f0' -Verb RunAs"
exit /b

:admin_ok
echo.
echo ██████████████████████████████████████████████████████████
echo █                                                        █
echo █    🎤 TRANSCRIPTEUR AUDIO PRO - INSTALLATEUR           █
echo █                      Version 2.0                      █
echo ██████████████████████████████████████████████████████████
echo.

REM Variables d'installation
set "APP_NAME=Transcripteur Audio PRO"
set "APP_VERSION=2.0"
set "APP_PUBLISHER=VotreNom"
set "INSTALL_DIR=%ProgramFiles%\TranscripteurAudioPRO"
set "DESKTOP=%USERPROFILE%\Desktop"
set "START_MENU=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
set "SOURCE_DIR=%~dp0"

echo 📋 BIENVENUE DANS L'INSTALLATEUR DU TRANSCRIPTEUR AUDIO PRO
echo.
echo 🎯 Cet assistant va installer l'application sur votre ordinateur.
echo.
echo 📂 Dossier d'installation : %INSTALL_DIR%
echo 🖥️  Raccourcis bureau et menu démarrer disponibles
echo 📦 Taille approximative : 50 MB
echo.

REM Vérifier si une version est déjà installée
if exist "%INSTALL_DIR%" (
    echo ⚠️  Une version du Transcripteur Audio PRO est déjà installée.
    echo.
    choice /C ORD /M "Remplacer (R), Désinstaller (D) ou Annuler (O)"
    if errorlevel 3 goto :uninstall_existing
    if errorlevel 2 goto :cancel_install
    if errorlevel 1 goto :replace_install
) else (
    goto :new_install
)

:replace_install
echo.
echo 🔄 Remplacement de l'installation existante...
goto :start_install

:new_install
echo.
echo ✨ Nouvelle installation détectée.

:start_install
echo.
echo 📁 CHOIX DES COMPOSANTS À INSTALLER :
echo.

REM Choix des composants
set "INSTALL_DESKTOP_SHORTCUT=Y"
set "INSTALL_STARTMENU=Y"
set "INSTALL_CONTEXT_MENU=N"
set "ADD_TO_PATH=N"

choice /C ON /M "Créer un raccourci sur le bureau (O/N)"
if errorlevel 2 set "INSTALL_DESKTOP_SHORTCUT=N"
if errorlevel 1 set "INSTALL_DESKTOP_SHORTCUT=Y"

choice /C ON /M "Ajouter au menu Démarrer (O/N)"
if errorlevel 2 set "INSTALL_STARTMENU=N"
if errorlevel 1 set "INSTALL_STARTMENU=Y"

choice /C ON /M "Ajouter 'Transcrire avec IA' au menu contextuel des fichiers audio (O/N)"
if errorlevel 2 set "INSTALL_CONTEXT_MENU=N"
if errorlevel 1 set "INSTALL_CONTEXT_MENU=Y"

choice /C ON /M "Ajouter le dossier au PATH système (accès en ligne de commande) (O/N)"
if errorlevel 2 set "ADD_TO_PATH=N"
if errorlevel 1 set "ADD_TO_PATH=Y"

echo.
echo 📋 RÉCAPITULATIF DE L'INSTALLATION :
echo.
echo 📂 Dossier d'installation : %INSTALL_DIR%
echo 🖥️  Raccourci bureau : %INSTALL_DESKTOP_SHORTCUT%
echo 📱 Menu démarrer : %INSTALL_STARTMENU%
echo 🖱️  Menu contextuel : %INSTALL_CONTEXT_MENU%
echo 🛤️  Ajout au PATH : %ADD_TO_PATH%
echo.

choice /C OA /M "Continuer l'installation (O) ou Annuler (A)"
if errorlevel 2 goto :cancel_install

echo.
echo 🚀 DÉBUT DE L'INSTALLATION...
echo.

REM Étape 1 : Vérification des prérequis
echo 🔍 [1/8] Vérification des prérequis...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python n'est pas installé.
    echo.
    echo 📥 Voulez-vous télécharger et installer Python automatiquement ?
    choice /C OA /M "Oui (O) ou installer manuellement plus tard (A)"
    if errorlevel 2 goto :manual_python
    if errorlevel 1 goto :auto_install_python
) else (
    echo ✅ Python détecté
)

goto :continue_install

:auto_install_python
echo 📥 Téléchargement de Python...
powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.6/python-3.11.6-amd64.exe' -OutFile '%TEMP%\python_installer.exe'"
echo 🔧 Installation de Python...
"%TEMP%\python_installer.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
if errorlevel 1 (
    echo ❌ Erreur lors de l'installation de Python
    goto :error_exit
)
echo ✅ Python installé avec succès
goto :continue_install

:manual_python
echo.
echo 📋 INSTALLATION MANUELLE DE PYTHON REQUISE :
echo.
echo 1. Allez sur : https://www.python.org/downloads/
echo 2. Téléchargez la dernière version de Python
echo 3. ⚠️  IMPORTANT : Cochez "Add Python to PATH"
echo 4. Installez Python puis relancez cet installateur
echo.
pause
goto :cancel_install

:continue_install
REM Étape 2 : Création du dossier d'installation
echo 📁 [2/8] Création du dossier d'installation...
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%" 2>nul
)
mkdir "%INSTALL_DIR%" 2>nul
if not exist "%INSTALL_DIR%" (
    echo ❌ Impossible de créer le dossier d'installation
    goto :error_exit
)
echo ✅ Dossier créé : %INSTALL_DIR%

REM Étape 3 : Copie des fichiers
echo 📦 [3/8] Copie des fichiers de l'application...

copy "%SOURCE_DIR%transcripteur_pro.py" "%INSTALL_DIR%\" >nul
copy "%SOURCE_DIR%config_api.py" "%INSTALL_DIR%\" >nul
copy "%SOURCE_DIR%requirements.txt" "%INSTALL_DIR%\" >nul
copy "%SOURCE_DIR%LISEZ-MOI-DABORD.txt" "%INSTALL_DIR%\" >nul

REM Créer les dossiers nécessaires
mkdir "%INSTALL_DIR%\temp" 2>nul
mkdir "%INSTALL_DIR%\exports" 2>nul
mkdir "%INSTALL_DIR%\config" 2>nul
mkdir "%INSTALL_DIR%\docs" 2>nul

if exist "%SOURCE_DIR%docs\guide-utilisation.html" (
    copy "%SOURCE_DIR%docs\guide-utilisation.html" "%INSTALL_DIR%\docs\" >nul
)

echo ✅ Fichiers copiés avec succès

REM Étape 4 : Installation des dépendances Python
echo 🐍 [4/8] Installation des dépendances Python...
cd /d "%INSTALL_DIR%"
python -m pip install --upgrade pip --quiet
python -m pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo ❌ Erreur lors de l'installation des dépendances
    goto :error_exit
)
echo ✅ Dépendances installées

REM Étape 5 : Création des scripts de lancement
echo 🔧 [5/8] Création des scripts de lancement...

REM Script de lancement principal
echo @echo off > "%INSTALL_DIR%\Lancer_Transcripteur.bat"
echo cd /d "%INSTALL_DIR%" >> "%INSTALL_DIR%\Lancer_Transcripteur.bat"
echo if not exist "config\api_key.env" ( >> "%INSTALL_DIR%\Lancer_Transcripteur.bat"
echo     call "Configurer_API.bat" >> "%INSTALL_DIR%\Lancer_Transcripteur.bat"
echo ) >> "%INSTALL_DIR%\Lancer_Transcripteur.bat"
echo start "" http://localhost:8501 >> "%INSTALL_DIR%\Lancer_Transcripteur.bat"
echo streamlit run transcripteur_pro.py --server.headless true --server.port 8501 --browser.gatherUsageStats false >> "%INSTALL_DIR%\Lancer_Transcripteur.bat"

REM Script de configuration API
echo @echo off > "%INSTALL_DIR%\Configurer_API.bat"
echo cd /d "%INSTALL_DIR%" >> "%INSTALL_DIR%\Configurer_API.bat"
echo python -c "from config_api import api_manager; api_manager.show_config_interface()" >> "%INSTALL_DIR%\Configurer_API.bat"
echo pause >> "%INSTALL_DIR%\Configurer_API.bat"

REM Script de désinstallation
echo @echo off > "%INSTALL_DIR%\Desinstaller.bat"
echo echo Désinstallation du Transcripteur Audio PRO... >> "%INSTALL_DIR%\Desinstaller.bat"
echo cd /d "%ProgramFiles%" >> "%INSTALL_DIR%\Desinstaller.bat"
echo rmdir /s /q "TranscripteurAudioPRO" >> "%INSTALL_DIR%\Desinstaller.bat"
echo del "%DESKTOP%\Transcripteur Audio PRO.lnk" 2^>nul >> "%INSTALL_DIR%\Desinstaller.bat"
echo rmdir /s /q "%START_MENU%\Transcripteur Audio PRO" 2^>nul >> "%INSTALL_DIR%\Desinstaller.bat"
echo echo Désinstallation terminée ! >> "%INSTALL_DIR%\Desinstaller.bat"
echo pause >> "%INSTALL_DIR%\Desinstaller.bat"

echo ✅ Scripts créés

REM Étape 6 : Création des raccourcis bureau
if "%INSTALL_DESKTOP_SHORTCUT%"=="Y" (
    echo 🖥️  [6/8] Création du raccourci bureau...
    
    powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP%\Transcripteur Audio PRO.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\Lancer_Transcripteur.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Transcripteur Audio PRO - Transcription IA'; $Shortcut.Save()"
    
    if exist "%DESKTOP%\Transcripteur Audio PRO.lnk" (
        echo ✅ Raccourci bureau créé
    ) else (
        echo ⚠️  Impossible de créer le raccourci bureau
    )
) else (
    echo ⏭️  [6/8] Raccourci bureau ignoré (non demandé)
)

REM Étape 7 : Création de l'entrée menu démarrer
if "%INSTALL_STARTMENU%"=="Y" (
    echo 📱 [7/8] Création de l'entrée menu démarrer...
    
    mkdir "%START_MENU%\Transcripteur Audio PRO" 2>nul
    
    powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU%\Transcripteur Audio PRO\Transcripteur Audio PRO.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\Lancer_Transcripteur.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Transcripteur Audio PRO'; $Shortcut.Save()"
    
    powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU%\Transcripteur Audio PRO\Configurer API.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\Configurer_API.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Configurer la clé API OpenAI'; $Shortcut.Save()"
    
    powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_MENU%\Transcripteur Audio PRO\Désinstaller.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\Desinstaller.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Désinstaller le Transcripteur Audio PRO'; $Shortcut.Save()"
    
    echo ✅ Menu démarrer configuré
) else (
    echo ⏭️  [7/8] Menu démarrer ignoré (non demandé)
)

REM Étape 8 : Configuration optionnelle du menu contextuel
if "%INSTALL_CONTEXT_MENU%"=="Y" (
    echo 🖱️  [8/8] Configuration du menu contextuel...
    
    REM Ajouter au registre pour les fichiers audio
    reg add "HKEY_CLASSES_ROOT\*\shell\TranscrireAvecIA" /ve /d "Transcrire avec IA" /f >nul 2>&1
    reg add "HKEY_CLASSES_ROOT\*\shell\TranscrireAvecIA\command" /ve /d "\"%INSTALL_DIR%\Lancer_Transcripteur.bat\"" /f >nul 2>&1
    
    echo ✅ Menu contextuel configuré
) else (
    echo ⏭️  [8/8] Menu contextuel ignoré (non demandé)
)

REM Ajout au PATH si demandé
if "%ADD_TO_PATH%"=="Y" (
    echo 🛤️  Ajout au PATH système...
    
    REM Ajouter au PATH utilisateur (plus sûr que système)
    for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "CURRENT_PATH=%%B"
    if not defined CURRENT_PATH set "CURRENT_PATH="
    
    echo %CURRENT_PATH% | find "%INSTALL_DIR%" >nul
    if errorlevel 1 (
        if defined CURRENT_PATH (
            reg add "HKCU\Environment" /v PATH /d "%CURRENT_PATH%;%INSTALL_DIR%" /f >nul
        ) else (
            reg add "HKCU\Environment" /v PATH /d "%INSTALL_DIR%" /f >nul
        )
        echo ✅ Ajouté au PATH
    ) else (
        echo ✅ Déjà dans le PATH
    )
)

REM Configuration initiale
echo 📝 Configuration initiale...
echo {"language": "auto", "summary_types": ["brief"], "auto_export": true, "concurrent_files": 3, "max_file_size_mb": 25} > "%INSTALL_DIR%\config\settings.json"

echo.
echo ██████████████████████████████████████████████████████████
echo █                                                        █
echo █    ✅ INSTALLATION TERMINÉE AVEC SUCCÈS !              █
echo █                                                        █
echo ██████████████████████████████████████████████████████████
echo.
echo 🎉 Le Transcripteur Audio PRO a été installé !
echo.
echo 📂 Dossier d'installation : %INSTALL_DIR%
if "%INSTALL_DESKTOP_SHORTCUT%"=="Y" echo 🖥️  Raccourci bureau : Créé
if "%INSTALL_STARTMENU%"=="Y" echo 📱 Menu démarrer : Configuré
if "%INSTALL_CONTEXT_MENU%"=="Y" echo 🖱️  Menu contextuel : Activé
echo.
echo 🚀 PROCHAINES ÉTAPES :
echo    1️⃣  Configurez votre clé API OpenAI (obligatoire)
echo    2️⃣  Lancez l'application depuis le bureau ou le menu démarrer
echo.

choice /C OCA /M "Configurer la clé API maintenant (O), Lancer l'app (L), ou terminer (A)"
if errorlevel 3 goto :end_install
if errorlevel 2 goto :launch_app
if errorlevel 1 goto :config_api

:config_api
echo.
echo 🔑 Lancement de la configuration API...
call "%INSTALL_DIR%\Configurer_API.bat"
goto :end_install

:launch_app
echo.
echo 🚀 Lancement de l'application...
call "%INSTALL_DIR%\Lancer_Transcripteur.bat"
goto :end_install

:uninstall_existing
echo.
echo 🗑️  Désinstallation de la version existante...
call "%INSTALL_DIR%\Desinstaller.bat"
echo.
echo 🔄 Redémarrez l'installateur pour installer la nouvelle version.
goto :end_install

:cancel_install
echo.
echo ❌ Installation annulée par l'utilisateur.
goto :end_install

:error_exit
echo.
echo ❌ ERREUR LORS DE L'INSTALLATION
echo 🔧 Contactez le support technique avec les détails de l'erreur.
pause
exit /b 1

:end_install
echo.
echo 👋 Merci d'avoir choisi le Transcripteur Audio PRO !
echo 📚 Consultez le guide d'utilisation dans docs\guide-utilisation.html
echo.
pause
exit /b 0
