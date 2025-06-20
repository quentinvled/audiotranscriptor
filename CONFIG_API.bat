@echo off
cls
echo Configuration de la cle API OpenAI
echo ==================================
echo.
set /p KEY=Entrez votre cle API : 
echo OPENAI_API_KEY=%KEY%> config\api_key.env
echo.
echo Cle sauvegardee !
pause
