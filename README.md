# 🎤 Transcripteur Audio PRO

> **Transcription audio professionnelle avec Intelligence Artificielle**  
> Powered by OpenAI Whisper + ChatGPT • Interface moderne • Installation Windows native

![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-lightgrey.svg)
![Python](https://img.shields.io/badge/python-3.8%2B-orange.svg)

---

## ✨ Aperçu

**Transcripteur Audio PRO** transforme vos fichiers audio en texte avec une précision exceptionnelle grâce à l'IA d'OpenAI. Interface moderne, installation professionnelle, et fonctionnalités avancées pour tous vos besoins de transcription.

### 🎯 Points forts
- 🤖 **IA de pointe** : Whisper (transcription) + ChatGPT (résumés)
- 🚀 **Multi-fichiers** : Traitement parallèle optimisé
- 📱 **Interface moderne** : Design professionnel avec Streamlit
- 💻 **Installation native** : Comme un vrai logiciel Windows
- 🔐 **Sécurisé** : Gestion locale et chiffrée des clés API
- 📊 **Temps réel** : Barres de progression et métriques live

---

## 🎬 Démonstration

<!-- TODO: Ajouter GIF de démonstration -->
```
[GIF montrant : Upload → Transcription → Résumés → Export]
```

### 🔥 Fonctionnalités principales

| Fonctionnalité | Description | Status |
|---|---|---|
| 🎙️ **Transcription multi-formats** | MP3, WAV, FLAC, M4A, MP4, WEBM... | ✅ |
| 🤖 **Résumés IA intelligents** | Bref, Points clés, Analyse complète | ✅ |
| 🔄 **Traitement parallèle** | Plusieurs fichiers simultanément | ✅ |
| 🌍 **Multi-langues** | Auto-détection + 20+ langues | ✅ |
| 💾 **Export automatique** | TXT, ZIP avec horodatage | ✅ |
| 📝 **Édition temps réel** | Modification des transcriptions | ✅ |
| 🖥️ **Installation pro** | Raccourcis, menu démarrer, désinstalleur | ✅ |
| 📊 **Métriques système** | RAM, disque, progression | ✅ |

---

## 📥 Installation

### 🚀 Installation automatique (recommandée)

1. **Téléchargez** la [dernière release](../../releases/latest)
2. **Décompressez** le fichier ZIP
3. **Clic-droit** sur `INSTALLER_PROFESSIONNEL.bat` → **"Exécuter en tant qu'administrateur"**
4. **Suivez** l'assistant d'installation
5. **Configurez** votre clé API OpenAI
6. **C'est prêt !** 🎉

### 📋 Prérequis

- **OS :** Windows 10/11 (64-bit recommandé)
- **RAM :** 4GB minimum, 8GB recommandé  
- **Espace :** 500MB libres
- **Internet :** Connexion stable (pour IA)
- **API :** Clé OpenAI (~0,006$/minute d'audio)

---

## 🔑 Configuration

### Obtenir une clé API OpenAI

1. 🌐 Allez sur [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. 👤 Créez un compte ou connectez-vous
3. ➕ Cliquez "Create new secret key"
4. 📋 Copiez la clé (commence par `sk-`)
5. 🔧 Utilisez l'assistant de configuration inclus

### Première utilisation

```bash
# Après installation, lancez depuis :
Menu Démarrer → Transcripteur Audio PRO
# ou
Double-clic sur l'icône bureau (si créée)
```

L'application vous guidera automatiquement pour configurer votre clé API.

---

## 🎯 Utilisation

### Interface principale

1. **📁 Upload** : Glissez-déposez vos fichiers audio
2. **⚙️ Paramètres** : Langue, types de résumés, options
3. **🚀 Transcription** : Cliquez et regardez la magie opérer
4. **📝 Résultats** : Transcriptions + résumés IA + exports

### Formats supportés

```
Audio : MP3, WAV, FLAC, M4A, OGG, WEBM
Vidéo : MP4, WEBM, MPEG, MPGA
Limite : 25MB par fichier
```

### Types de résumés

- **📄 Bref** : 2-3 phrases essentielles
- **🔹 Points clés** : Liste structurée et hiérarchique  
- **📋 Complet** : Analyse détaillée avec conclusion

---

## 🏗️ Pour les développeurs

### Installation développement

```bash
# Cloner le repository
git clone https://github.com/VOTRE_USERNAME/transcripteur-audio-pro.git
cd transcripteur-audio-pro

# Installer les dépendances
pip install -r requirements.txt

# Variables d'environnement
cp .env.example .env
# Éditer .env avec votre clé API

# Lancer en mode dev
streamlit run src/transcripteur_pro.py
```

### Structure du projet

```
src/
├── transcripteur_pro.py      # Application principale
├── config_api.py             # Gestion sécurisée des clés
└── utils/                    # Utilitaires
scripts/
├── INSTALLER_PROFESSIONNEL.bat  # Installateur Windows
└── dev/                      # Scripts de développement
docs/
├── guide-utilisation.html    # Guide utilisateur
└── api-reference.md          # Documentation API
```

### API Reference

```python
from src.config_api import get_openai_client
from src.transcripteur_pro import TranscripteurPro

# Initialiser
app = TranscripteurPro()

# Transcrire un fichier
transcript, error = app.transcribe_audio(audio_content, filename, language="fr")

# Générer un résumé
summary = app.generate_summary(transcript, "brief")
```

---

## 📊 Performances

### Benchmarks

| Critère | Performance |
|---|---|
| **Précision transcription** | 95%+ (audio clair) |
| **Vitesse traitement** | ~2x temps réel |
| **Langues supportées** | 20+ (auto-détection) |
| **Fichiers simultanés** | 1-5 (configurable) |
| **Mémoire utilisée** | ~200-500MB |

### Optimisations

- ✅ **Cache intelligent** : Évite les re-calculs
- ✅ **Traitement parallèle** : Multi-threading optimisé
- ✅ **Compression temporaire** : Fichiers légers
- ✅ **Monitoring système** : RAM/CPU en temps réel

---

## 🛣️ Roadmap

### Version 2.1 (Q1 2024)
- [ ] 🎨 Thèmes visuels multiples
- [ ] 🌐 Interface multilingue
- [ ] 📱 Mode portable (sans installation)
- [ ] 🔄 Auto-update intégré

### Version 2.2 (Q2 2024)
- [ ] 🎭 Reconnaissance de locuteurs
- [ ] ☁️ Intégration cloud (Drive, Dropbox)
- [ ] 📊 Tableau de bord analytics
- [ ] 🔌 API REST publique

### Long terme
- [ ] 📱 Application mobile
- [ ] 🌐 Version web en ligne
- [ ] 🤝 Intégrations entreprise
- [ ] 🧠 IA personnalisée

---

## 🤝 Contribution

### Comment contribuer

1. 🍴 **Fork** le repository
2. 🌿 **Créez** une branche feature (`git checkout -b feature/amazing-feature`)
3. 💾 **Commitez** vos changements (`git commit -m 'Add amazing feature'`)
4. 📤 **Push** vers la branche (`git push origin feature/amazing-feature`)
5. 📝 **Ouvrez** une Pull Request

### Guidelines

- 📝 **Code style** : PEP 8 pour Python
- 🧪 **Tests** : Ajoutez des tests pour les nouvelles features
- 📚 **Documentation** : Mettez à jour la doc si nécessaire
- 💬 **Messages** : Commits en anglais, descriptifs

---

## 📞 Support

### 🆘 Problèmes courants

| Problème | Solution |
|---|---|
| "Python non détecté" | Installez Python avec "Add to PATH" |
| "Clé API invalide" | Vérifiez sur platform.openai.com |
| "Fichier trop volumineux" | Compressez en MP3 < 25MB |
| Application lente | Réduisez fichiers simultanés |

### 📚 Documentation

- 📖 **Guide utilisateur** : [docs/guide-utilisation.html](docs/guide-utilisation.html)
- 🔧 **Troubleshooting** : [docs/troubleshooting.md](docs/troubleshooting.md)
- 💻 **API Reference** : [docs/api-reference.md](docs/api-reference.md)

### 🐛 Signaler un bug

[Ouvrez une issue](../../issues/new) avec :
- 🖥️ Version Windows
- 🐍 Version Python (`python --version`)
- 📝 Message d'erreur exact
- 🔄 Étapes pour reproduire

---

## 📄 Licence

Ce projet est sous licence **MIT** - voir [LICENSE](LICENSE) pour plus de détails.

### Utilisation commerciale
✅ Autorisée avec attribution  
✅ Modification et redistribution permises  
✅ Usage privé et commercial libre  

---

## 💝 Remerciements

- 🤖 **OpenAI** pour Whisper et ChatGPT
- 🚀 **Streamlit** pour l'interface moderne
- 🐍 **Python Community** pour l'écosystème fantastique
- 👥 **Testeurs beta** pour les retours précieux

---

## 📈 Stats

![GitHub stars](https://img.shields.io/github/stars/VOTRE_USERNAME/transcripteur-audio-pro?style=social)
![GitHub forks](https://img.shields.io/github/forks/VOTRE_USERNAME/transcripteur-audio-pro?style=social)
![GitHub issues](https://img.shields.io/github/issues/VOTRE_USERNAME/transcripteur-audio-pro)
![GitHub downloads](https://img.shields.io/github/downloads/VOTRE_USERNAME/transcripteur-audio-pro/total)

---

<div align="center">

**🎤 Transcripteur Audio PRO**

*Made with ❤️ for audio professionals*

[⬆️ Retour en haut](#-transcripteur-audio-pro)

</div>
