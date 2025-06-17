@echo off
REM 🎯 INSTALLATEUR TRANSCRIPTEUR AUDIO PRO
REM Interface graphique moderne avec PowerShell + Windows Forms

title Transcripteur Audio PRO - Installation

REM Lancer l'interface graphique PowerShell
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& {
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Configuration
$global:GITHUB_USER = 'quentinvled'  # ← CHANGEZ par votre username
$global:GITHUB_REPO = 'audiotranscriptor'  # ← CHANGEZ par votre repo
$global:INSTALL_DIR = Join-Path $env:USERPROFILE 'TranscripteurAudioPro'

# Variables globales
$global:installForm = $null
$global:progressBar = $null
$global:statusLabel = $null
$global:logTextBox = $null
$global:installThread = $null

# Fonction pour logger
function Write-Log($message, $color = 'Black') {
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $logMessage = \"[$timestamp] $message\"
    
    if ($global:logTextBox) {
        $global:logTextBox.Invoke([Action]{
            $global:logTextBox.AppendText($logMessage + \"`r`n\")
            $global:logTextBox.ScrollToCaret()
        })
    }
}

# Fonction pour mettre à jour le statut
function Update-Status($message) {
    if ($global:statusLabel) {
        $global:statusLabel.Invoke([Action]{
            $global:statusLabel.Text = $message
        })
    }
    Write-Log $message
}

# Fonction pour mettre à jour la progression
function Update-Progress($value) {
    if ($global:progressBar) {
        $global:progressBar.Invoke([Action]{
            $global:progressBar.Value = $value
        })
    }
}

# Fonction principale d'installation
function Start-Installation {
    try {
        Write-Log '=== DÉBUT DE L''INSTALLATION ==='
        
        # Étape 1: Vérifier Python
        Update-Status 'Vérification de Python...'
        Update-Progress 10
        
        $pythonCmd = $null
        foreach ($cmd in @('python', 'py', 'python3')) {
            try {
                $version = & $cmd --version 2>$null
                if ($LASTEXITCODE -eq 0) {
                    $pythonCmd = $cmd
                    Write-Log \"Python trouvé : $version\"
                    break
                }
            } catch { }
        }
        
        if (-not $pythonCmd) {
            Update-Status 'Installation de Python...'
            Write-Log 'Python non détecté, installation automatique...'
            
            # Télécharger Python
            $pythonUrl = 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe'
            $pythonInstaller = Join-Path $env:TEMP 'python_installer.exe'
            
            Write-Log 'Téléchargement de Python...'
            Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller -UseBasicParsing
            
            Write-Log 'Installation de Python en cours...'
            Start-Process -FilePath $pythonInstaller -ArgumentList '/quiet', 'InstallAllUsers=0', 'PrependPath=1', 'Include_test=0' -Wait
            Remove-Item $pythonInstaller -Force
            
            # Vérifier à nouveau
            Start-Sleep 3
            foreach ($cmd in @('python', 'py')) {
                try {
                    $version = & $cmd --version 2>$null
                    if ($LASTEXITCODE -eq 0) {
                        $pythonCmd = $cmd
                        Write-Log \"Python installé avec succès : $version\"
                        break
                    }
                } catch { }
            }
            
            if (-not $pythonCmd) {
                throw 'Échec de l''installation de Python'
            }
        }
        
        # Étape 2: Créer le dossier
        Update-Status 'Création du dossier d''installation...'
        Update-Progress 25
        
        if (-not (Test-Path $global:INSTALL_DIR)) {
            New-Item -ItemType Directory -Path $global:INSTALL_DIR -Force | Out-Null
        }
        Write-Log \"Dossier créé : $global:INSTALL_DIR\"
        
        # Étape 3: Télécharger l'application
        Update-Status 'Téléchargement de l''application...'
        Update-Progress 40
        
        $downloadUrl = \"https://github.com/$global:GITHUB_USER/$global:GITHUB_REPO/archive/refs/heads/main.zip\"
        $zipPath = Join-Path $global:INSTALL_DIR 'app.zip'
        
        Write-Log \"Téléchargement depuis : $downloadUrl\"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
        
        # Extraire
        Write-Log 'Extraction des fichiers...'
        Expand-Archive -Path $zipPath -DestinationPath $global:INSTALL_DIR -Force
        
        # Déplacer les fichiers du sous-dossier
        $extractedFolder = Join-Path $global:INSTALL_DIR \"$global:GITHUB_REPO-main\"
        if (Test-Path $extractedFolder) {
            Get-ChildItem $extractedFolder | Move-Item -Destination $global:INSTALL_DIR -Force
            Remove-Item $extractedFolder -Recurse -Force
        }
        Remove-Item $zipPath -Force
        
        # Étape 4: Installer les dépendances
        Update-Status 'Installation des dépendances...'
        Update-Progress 60
        
        Write-Log 'Mise à jour de pip...'
        & $pythonCmd -m pip install --upgrade pip | Out-Null
        
        $requirementsFile = Join-Path $global:INSTALL_DIR 'requirements.txt'
        if (Test-Path $requirementsFile) {
            Write-Log 'Installation depuis requirements.txt...'
            & $pythonCmd -m pip install -r $requirementsFile | Out-Null
        } else {
            Write-Log 'Installation des packages principaux...'
            $packages = @('streamlit', 'openai', 'python-dotenv', 'requests', 'psutil')
            foreach ($package in $packages) {
                Write-Log \"Installation de $package...\"
                & $pythonCmd -m pip install $package | Out-Null
            }
        }
        
        # Étape 5: Créer les scripts
        Update-Status 'Configuration...'
        Update-Progress 80
        
        # Script de lancement
        $launcherScript = @\"
@echo off
title Transcripteur Audio PRO
cd /d \"$global:INSTALL_DIR\"
echo 🎤 Démarrage de Transcripteur Audio PRO...
echo ✨ L'application s'ouvrira dans votre navigateur
echo 🌐 URL : http://localhost:8501
echo.
$pythonCmd -m streamlit run src/transcripteur_pro.py --server.headless false --server.port 8501 --browser.gatherUsageStats false
pause
\"@
        
        $launcherPath = Join-Path $global:INSTALL_DIR 'Lancer_Transcripteur.bat'
        $launcherScript | Out-File -FilePath $launcherPath -Encoding UTF8
        
        # Guide d'utilisation
        $guide = @\"
🎤 TRANSCRIPTEUR AUDIO PRO - GUIDE RAPIDE
============================================

🚀 DÉMARRAGE:
1. Double-cliquez sur \"Transcripteur Audio PRO\" (bureau)
2. Configurez votre clé API OpenAI au premier lancement
3. Glissez vos fichiers audio dans l'interface
4. Cliquez TRANSCRIRE !

🔑 CLÉ API OPENAI:
Obtenez-la gratuitement: https://platform.openai.com/api-keys

💰 COÛT: ~0,006$ par minute d'audio
📁 FORMATS: MP3, WAV, FLAC, M4A, MP4

🆘 SUPPORT: GitHub.com/$global:GITHUB_USER/$global:GITHUB_REPO

Bon usage ! 🎉
\"@
        
        $guidePath = Join-Path $global:INSTALL_DIR 'GUIDE.txt'
        $guide | Out-File -FilePath $guidePath -Encoding UTF8
        
        # Étape 6: Raccourcis
        Update-Status 'Création des raccourcis...'
        Update-Progress 95
        
        # Raccourci bureau
        $desktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcutPath = Join-Path $desktopPath 'Transcripteur Audio PRO.bat'
        
        $shortcutContent = @\"
@echo off
cd /d \"$global:INSTALL_DIR\"
call \"Lancer_Transcripteur.bat\"
\"@
        
        $shortcutContent | Out-File -FilePath $shortcutPath -Encoding UTF8
        Write-Log 'Raccourci bureau créé'
        
        # Terminé !
        Update-Status 'Installation terminée !'
        Update-Progress 100
        Write-Log '=== INSTALLATION TERMINÉE AVEC SUCCÈS ==='
        
        # Afficher le message de succès
        Show-CompletionDialog
        
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log \"ERREUR : $errorMessage\" 'Red'
        Update-Status \"Erreur : $errorMessage\"
        [System.Windows.Forms.MessageBox]::Show(\"Erreur d'installation :`n$errorMessage\", 'Erreur', 'OK', 'Error')
    }
}

# Interface de fin d'installation
function Show-CompletionDialog {
    $completionForm = New-Object System.Windows.Forms.Form
    $completionForm.Text = 'Installation terminée'
    $completionForm.Size = New-Object System.Drawing.Size(500, 300)
    $completionForm.StartPosition = 'CenterScreen'
    $completionForm.FormBorderStyle = 'FixedDialog'
    $completionForm.MaximizeBox = $false
    $completionForm.MinimizeBox = $false
    $completionForm.TopMost = $true
    
    # Icône de succès
    $successLabel = New-Object System.Windows.Forms.Label
    $successLabel.Text = '✅ Installation terminée avec succès !'
    $successLabel.Font = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)
    $successLabel.ForeColor = [System.Drawing.Color]::Green
    $successLabel.AutoSize = $true
    $successLabel.Location = New-Object System.Drawing.Point(50, 30)
    $completionForm.Controls.Add($successLabel)
    
    # Informations
    $infoLabel = New-Object System.Windows.Forms.Label
    $infoLabel.Text = \"Application installée dans :`n$global:INSTALL_DIR`n`nRaccourci créé sur le bureau`nGuide d'utilisation disponible\"
    $infoLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $infoLabel.AutoSize = $true
    $infoLabel.Location = New-Object System.Drawing.Point(50, 80)
    $completionForm.Controls.Add($infoLabel)
    
    # Bouton Lancer
    $launchButton = New-Object System.Windows.Forms.Button
    $launchButton.Text = '🚀 Lancer maintenant'
    $launchButton.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
    $launchButton.Size = New-Object System.Drawing.Size(150, 40)
    $launchButton.Location = New-Object System.Drawing.Point(50, 200)
    $launchButton.BackColor = [System.Drawing.Color]::LimeGreen
    $launchButton.ForeColor = [System.Drawing.Color]::White
    $launchButton.FlatStyle = 'Flat'
    $launchButton.Add_Click({
        try {
            $launcherPath = Join-Path $global:INSTALL_DIR 'Lancer_Transcripteur.bat'
            Start-Process -FilePath $launcherPath
            $completionForm.Close()
            $global:installForm.Close()
        } catch {
            [System.Windows.Forms.MessageBox]::Show('Erreur lors du lancement', 'Erreur', 'OK', 'Error')
        }
    })
    $completionForm.Controls.Add($launchButton)
    
    # Bouton Fermer
    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = 'Fermer'
    $closeButton.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $closeButton.Size = New-Object System.Drawing.Size(100, 40)
    $closeButton.Location = New-Object System.Drawing.Point(220, 200)
    $closeButton.Add_Click({
        $completionForm.Close()
        $global:installForm.Close()
    })
    $completionForm.Controls.Add($closeButton)
    
    $completionForm.ShowDialog()
}

# Interface principale d'installation
function Show-InstallationDialog {
    $global:installForm = New-Object System.Windows.Forms.Form
    $global:installForm.Text = 'Transcripteur Audio PRO - Installation'
    $global:installForm.Size = New-Object System.Drawing.Size(600, 500)
    $global:installForm.StartPosition = 'CenterScreen'
    $global:installForm.FormBorderStyle = 'FixedDialog'
    $global:installForm.MaximizeBox = $false
    $global:installForm.BackColor = [System.Drawing.Color]::White
    
    # En-tête avec style
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Size = New-Object System.Drawing.Size(600, 80)
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
    $global:installForm.Controls.Add($headerPanel)
    
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = '🎤 Transcripteur Audio PRO'
    $titleLabel.Font = New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::White
    $titleLabel.AutoSize = $true
    $titleLabel.Location = New-Object System.Drawing.Point(20, 15)
    $headerPanel.Controls.Add($titleLabel)
    
    $subtitleLabel = New-Object System.Windows.Forms.Label
    $subtitleLabel.Text = 'Installation automatique avec interface moderne'
    $subtitleLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $subtitleLabel.ForeColor = [System.Drawing.Color]::LightGray
    $subtitleLabel.AutoSize = $true
    $subtitleLabel.Location = New-Object System.Drawing.Point(20, 45)
    $headerPanel.Controls.Add($subtitleLabel)
    
    # Description
    $descLabel = New-Object System.Windows.Forms.Label
    $descLabel.Text = @\"
Cette application vous permet de :
• Transcrire automatiquement vos fichiers audio avec l'IA
• Générer des résumés intelligents 
• Traiter plusieurs fichiers simultanément
• Interface moderne et intuitive

L'installation prend 3-5 minutes et configure tout automatiquement.
\"@
    $descLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $descLabel.AutoSize = $true
    $descLabel.Location = New-Object System.Drawing.Point(30, 100)
    $global:installForm.Controls.Add($descLabel)
    
    # Dossier d'installation
    $folderLabel = New-Object System.Windows.Forms.Label
    $folderLabel.Text = '📁 Dossier d''installation :'
    $folderLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
    $folderLabel.AutoSize = $true
    $folderLabel.Location = New-Object System.Drawing.Point(30, 220)
    $global:installForm.Controls.Add($folderLabel)
    
    $folderTextBox = New-Object System.Windows.Forms.TextBox
    $folderTextBox.Text = $global:INSTALL_DIR
    $folderTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 9)
    $folderTextBox.Size = New-Object System.Drawing.Size(500, 25)
    $folderTextBox.Location = New-Object System.Drawing.Point(30, 245)
    $folderTextBox.ReadOnly = $true
    $folderTextBox.BackColor = [System.Drawing.Color]::LightGray
    $global:installForm.Controls.Add($folderTextBox)
    
    # Zone de progression (initialement cachée)
    $progressPanel = New-Object System.Windows.Forms.Panel
    $progressPanel.Size = New-Object System.Drawing.Size(540, 120)
    $progressPanel.Location = New-Object System.Drawing.Point(30, 280)
    $progressPanel.Visible = $false
    $global:installForm.Controls.Add($progressPanel)
    
    $global:statusLabel = New-Object System.Windows.Forms.Label
    $global:statusLabel.Text = 'Prêt à installer...'
    $global:statusLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
    $global:statusLabel.AutoSize = $true
    $global:statusLabel.Location = New-Object System.Drawing.Point(0, 0)
    $progressPanel.Controls.Add($global:statusLabel)
    
    $global:progressBar = New-Object System.Windows.Forms.ProgressBar
    $global:progressBar.Size = New-Object System.Drawing.Size(540, 25)
    $global:progressBar.Location = New-Object System.Drawing.Point(0, 25)
    $global:progressBar.Style = 'Continuous'
    $progressPanel.Controls.Add($global:progressBar)
    
    $global:logTextBox = New-Object System.Windows.Forms.TextBox
    $global:logTextBox.Size = New-Object System.Drawing.Size(540, 80)
    $global:logTextBox.Location = New-Object System.Drawing.Point(0, 60)
    $global:logTextBox.Multiline = $true
    $global:logTextBox.ScrollBars = 'Vertical'
    $global:logTextBox.ReadOnly = $true
    $global:logTextBox.Font = New-Object System.Drawing.Font('Consolas', 8)
    $global:logTextBox.BackColor = [System.Drawing.Color]::Black
    $global:logTextBox.ForeColor = [System.Drawing.Color]::LimeGreen
    $progressPanel.Controls.Add($global:logTextBox)
    
    # Boutons
    $buttonPanel = New-Object System.Windows.Forms.Panel
    $buttonPanel.Size = New-Object System.Drawing.Size(600, 60)
    $buttonPanel.Location = New-Object System.Drawing.Point(0, 420)
    $global:installForm.Controls.Add($buttonPanel)
    
    $installButton = New-Object System.Windows.Forms.Button
    $installButton.Text = '🚀 INSTALLER'
    $installButton.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
    $installButton.Size = New-Object System.Drawing.Size(150, 40)
    $installButton.Location = New-Object System.Drawing.Point(350, 10)
    $installButton.BackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    $installButton.ForeColor = [System.Drawing.Color]::White
    $installButton.FlatStyle = 'Flat'
    $installButton.Add_Click({
        $installButton.Enabled = $false
        $installButton.Text = 'Installation...'
        $progressPanel.Visible = $true
        $global:installForm.Height = 580
        
        # Lancer l'installation dans un thread séparé
        $runspace = [powershell]::Create()
        $runspace.AddScript({ Start-Installation })
        $runspace.BeginInvoke()
    })
    $buttonPanel.Controls.Add($installButton)
    
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = 'Annuler'
    $cancelButton.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $cancelButton.Size = New-Object System.Drawing.Size(100, 40)
    $cancelButton.Location = New-Object System.Drawing.Point(230, 10)
    $cancelButton.Add_Click({
        $global:installForm.Close()
    })
    $buttonPanel.Controls.Add($cancelButton)
    
    # Afficher le formulaire
    $global:installForm.ShowDialog() | Out-Null
}

# Lancer l'interface
Show-InstallationDialog
}"

REM Le script PowerShell se termine, on peut ajouter du nettoyage ici si nécessaire
exit /b 0