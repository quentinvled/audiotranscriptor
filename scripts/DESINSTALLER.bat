@echo off
chcp 65001 >nul
cls
color 0C

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
echo ⚠️  La désinstallation nécessite des droits administrateur
echo.
powershell -Command "Start-Process '%~f0' -Verb RunAs"
exit /b

:admin_ok
echo.
echo ██████████████████████████████████████████████████████████
echo █                                                        █
echo █    🗑️  DÉSINSTALLATION - TRANSCRIPTEUR AUDIO PRO       █
echo █                                                        █
echo ██████████████████████████████████████████████████████████
echo.

set "INSTALL_DIR=%ProgramFiles%\TranscripteurAudioPRO"
set "DESKTOP=%USERPROFILE%\Desktop"
set "START_MENU=%ProgramData%\Microsoft\Windows\Start Menu\Programs"

echo ⚠️  ATTENTION : Cette opération va supprimer complètement
echo    le Transcripteur Audio PRO de votre ordinateur.
echo.
echo 📂 Dossier à supprimer : %INSTALL_DIR%
echo 🖥️  Raccourcis bureau et menu démarrer
echo 🗃️  Paramètres et configuration
echo.

REM Vérifier si l'application est installée
if not exist "%INSTALL_DIR%" (
    echo ❌ Le Transcripteur Audio PRO ne semble pas être installé.
    echo 📂 Dossier non trouvé : %INSTALL_DIR%
    echo.
    pause
    exit /b 1
)

echo 💾 SAUVEGARDE DE VOS DONNÉES :
echo.
if exist "%INSTALL_DIR%\exports" (
    for /f %%i in ('dir /b "%INSTALL_DIR%\exports" 2^>nul ^| find /c /v ""') do set "EXPORT_COUNT=%%i"
    if not "!EXPORT_COUNT!"=="0" (
        echo ⚠️  IMPORTANT : Vous avez !EXPORT_COUNT! dossier(s) d'exports sauvegardés !
        echo 📁 Emplacement : %INSTALL_DIR%\exports\
        echo.
        choice /C OSA /M "Sauvegarder sur le bureau (O), Ignorer (S), ou Annuler (A)"
        if errorlevel 3 goto :cancel_uninstall
        if errorlevel 2 goto :continue_uninstall
        if errorlevel 1 goto :backup_exports
    )
) else (
    echo ✅ Aucune donnée utilisateur détectée
)

goto :continue_uninstall

:backup_exports
echo.
echo 💾 Sauvegarde des exports sur le bureau...
set "BACKUP_DIR=%DESKTOP%\Transcripteur_Sauvegarde_%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%"
mkdir "%BACKUP_DIR%" 2>nul
xcopy "%INSTALL_DIR%\exports\*" "%BACKUP_DIR%\" /E /I /Q >nul 2>&1
if exist "%BACKUP_DIR%" (
    echo ✅ Sauvegarde créée : %BACKUP_DIR%
) else (
    echo ❌ Erreur lors de la sauvegarde
    pause
    exit /b 1
)

:continue_uninstall
echo.
echo 🔥 DERNIÈRE CHANCE : Êtes-vous sûr de vouloir désinstaller ?
echo.
choice /C OA /M "Oui, désinstaller définitivement (O) ou Annuler (A)"
if errorlevel 2 goto :cancel_uninstall

echo.
echo 🗑️  DÉSINSTALLATION EN COURS...
echo.

REM Étape 1 : Arrêter les processus en cours
echo 🛑 [1/6] Arrêt des processus en cours...
taskkill /F /IM "python.exe" /FI "WINDOWTITLE eq Transcripteur*" 2>nul
taskkill /F /IM "streamlit.exe" 2>nul
timeout /t 2 /nobreak >nul
echo ✅ Processus arrêtés

REM Étape 2 : Suppression des raccourcis bureau
echo 🖥️  [2/6] Suppression des raccourcis bureau...
del "%DESKTOP%\Transcripteur Audio PRO.lnk" 2>nul
if exist "%DESKTOP%\Transcripteur Audio PRO.lnk" (
    echo ⚠️  Impossible de supprimer le raccourci bureau
) else (
    echo ✅ Raccourci bureau supprimé
)

REM Étape 3 : Suppression du menu démarrer
echo 📱 [3/6] Suppression du menu démarrer...
rmdir /s /q "%START_MENU%\Transcripteur Audio PRO" 2>nul
if exist "%START_MENU%\Transcripteur Audio PRO" (
    echo ⚠️  Impossible de supprimer complètement le menu démarrer
) else (
    echo ✅ Menu démarrer supprimé
)

REM Étape 4 : Suppression du menu contextuel
echo 🖱️  [4/6] Suppression du menu contextuel...
reg delete "HKEY_CLASSES_ROOT\*\shell\TranscrireAvecIA" /f 2>nul
echo ✅ Menu contextuel supprimé

REM Étape 5 : Suppression du PATH
echo 🛤️  [5/6] Nettoyage du PATH...
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "CURRENT_PATH=%%B"
if defined CURRENT_PATH (
    set "NEW_PATH=!CURRENT_PATH:%INSTALL_DIR%;=!"
    set "NEW_PATH=!NEW_PATH:;%INSTALL_DIR%=!"
    set "NEW_PATH=!NEW_PATH:%INSTALL_DIR%=!"
    reg add "HKCU\Environment" /v PATH /d "!NEW_PATH!" /f >nul 2>&1
    echo ✅ PATH nettoyé
) else (
    echo ✅ Rien à nettoyer dans le PATH
)

REM Étape 6 : Suppression du dossier principal
echo 📁 [6/6] Suppression du dossier d'installation...
cd /d "%ProgramFiles%"
rmdir /s /q "TranscripteurAudioPRO" 2>nul

REM Vérifier si la suppression a réussi
if exist "%INSTALL_DIR%" (
    echo ⚠️  Impossible de supprimer complètement le dossier d'installation
    echo 📂 Dossier restant : %INSTALL_DIR%
    echo 💡 Redémarrez votre ordinateur et supprimez-le manuellement si nécessaire
) else (
    echo ✅ Dossier d'installation supprimé
)

echo.
echo ██████████████████████████████████████████████████████████
echo █                                                        █
echo █    ✅ DÉSINSTALLATION TERMINÉE !                       █
echo █                                                        █
echo ██████████████████████████████████████████████████████████
echo.
echo 🎉 Le Transcripteur Audio PRO a été supprimé de votre ordinateur.
echo.

if exist "%BACKUP_DIR%" (
    echo 💾 Vos exports sauvegardés : %BACKUP_DIR%
)

echo.
echo 📋 ÉLÉMENTS SUPPRIMÉS :
echo    ✅ Application principale
echo    ✅ Raccourcis bureau
echo    ✅ Entrées menu démarrer
echo    ✅ Menu contextuel
echo    ✅ Configuration PATH
echo.
echo 💡 Les dépendances Python (streamlit, openai) restent installées
echo    et peuvent être utilisées par d'autres applications.
echo.
echo 😢 Nous sommes désolés de vous voir partir !
echo 📧 N'hésitez pas à nous faire part de vos commentaires.
echo.

pause
goto :end_uninstall

:cancel_uninstall
echo.
echo ❌ Désinstallation annulée par l'utilisateur.
echo 🎉 Le Transcripteur Audio PRO reste installé !

:end_uninstall
echo.
echo 👋 À bientôt !
pause
exit /b 0
