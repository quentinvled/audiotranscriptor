# 🎤 Vled Transcriptor

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![Installation](https://img.shields.io/badge/installation-automatique-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-yellow.svg)

**🤖 Transcription audio intelligente avec IA - Installation automatique complète !**

Transformez vos enregistrements audio en texte avec une précision exceptionnelle grâce à OpenAI Whisper, puis générez automatiquement des résumés avec ChatGPT. **Aucune compétence technique requise !**

## ⚡ Installation ultra-simple (3 clics)

### 🚀 **ÉTAPES RAPIDES :**

1. **📥 [TÉLÉCHARGER L'APPLICATION](https://github.com/VotreUsername/Vled-Transcriptor/archive/refs/heads/main.zip)** ← Clic direct !

2. **📂 EXTRAIRE** le fichier ZIP dans un dossier

3. **🚀 DOUBLE-CLIC** sur `1_INSTALLER.bat` et attendez (5-10 min)

4. **🔑 DOUBLE-CLIC** sur `3_CONFIGURER-CLE-API.bat` pour la clé OpenAI gratuite

5. **▶️ DOUBLE-CLIC** sur `2_LANCER.bat` pour utiliser l'application !

**C'est tout ! 🎉 L'application s'installe automatiquement avec Python + toutes les dépendances !**

---

## ✨ Ce que fait Vled Transcriptor

| Fonctionnalité | Description | Exemple |
|----------------|-------------|---------|
| 🎤 **Transcription ultra-précise** | Convertit vos audios en texte | Cours, réunions, interviews |
| 🤖 **Résumés automatiques** | 3 formats : bref, points clés, complet | Synthèse intelligente de vos enregistrements |
| 📁 **Multi-fichiers** | Traite plusieurs audios en parallèle | Dossier complet de cours en une fois |
| 🌐 **Interface moderne** | Web app qui s'ouvre dans votre navigateur | Design intuitif, glisser-déposer |
| 💾 **Export automatique** | Sauvegarde tout dans le dossier "exports" | Organisation automatique de vos transcriptions |
| 🌍 **Multilingue** | Détection automatique de la langue | Français, anglais, espagnol, etc. |

---

## 🎯 Formats supportés

### 📼 **Audio :**
MP3, WAV, FLAC, M4A, OGG

### 🎬 **Vidéo :** 
MP4, WEBM (extraction audio automatique)

### 📏 **Taille :**
Jusqu'à 25 MB par fichier (configurable)

---

## 💰 Coût d'utilisation (très abordable !)

| Type | Coût | Exemple concret |
|------|------|-----------------|
| 🎤 **Transcription** | ~0,006€/minute | 1h de cours = ~0,36€ |
| 🤖 **Résumé** | ~0,002€/résumé | 3 résumés = ~0,006€ |
| 💡 **Total** | ~0,40€/heure | Moins qu'un café ! ☕ |

**🎁 OpenAI offre des crédits gratuits pour commencer !**

---

## 🛠️ Que fait l'installation automatique ?

L'installateur `1_INSTALLER.bat` s'occupe de TOUT :

- ✅ **Détecte** si Python est installé
- ✅ **Télécharge et installe** Python 3.11 si nécessaire  
- ✅ **Installe** Streamlit (interface web)
- ✅ **Installe** OpenAI (transcription + résumés IA)
- ✅ **Installe** toutes les dépendances nécessaires
- ✅ **Configure** l'environnement complet
- ✅ **Teste** que tout fonctionne
- ✅ **Crée** les dossiers de travail

**Résultat :** Application prête à l'emploi, zéro manipulation manuelle !

---

## 🔑 Configuration de la clé API OpenAI

### **C'est gratuit et facile !**

Le script `3_CONFIGURER-CLE-API.bat` vous guide étape par étape :

1. **🌐 Aller sur :** [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. **👤 Créer un compte** OpenAI (gratuit)
3. **➕ Créer une clé** API gratuite  
4. **📋 Copier la clé** dans le script
5. **✅ Test automatique** de fonctionnement

**🔒 Sécurité :** Votre clé reste sur VOTRE ordinateur, stockage local chiffré.

---

## 📋 Guide d'utilisation rapide

### **1️⃣ Première utilisation**
- Lancez `2_LANCER.bat`
- L'interface s'ouvre dans votre navigateur sur `http://localhost:8501`

### **2️⃣ Transcription simple**
- Glissez-déposez votre fichier audio
- Choisissez la langue (ou auto-détection)
- Cliquez "Transcrire"
- Récupérez votre texte !

### **3️⃣ Résumés automatiques**
- Activez "Résumés automatiques"
- Choisissez : Bref / Points clés / Complet
- Le résumé se génère automatiquement

### **4️⃣ Export et sauvegarde**  
- Tout se sauvegarde dans le dossier `exports/`
- Téléchargement direct depuis l'interface
- Organisation automatique par date

---

## 🎬 Exemples d'utilisation

### 👨‍🎓 **Étudiants**
- Transcription de cours magistraux
- Résumés automatiques pour révisions
- Interviews et entretiens

### 💼 **Professionnels**  
- Comptes-rendus de réunions
- Transcription d'appels clients
- Podcasts et webinaires

### 🎙️ **Créateurs de contenu**
- Sous-titres pour vidéos YouTube
- Articles de blog depuis podcasts
- Documentation audio

---

## ❓ Dépannage rapide

### **❌ "Python non détecté"**
→ Relancez `1_INSTALLER.bat`, il installe Python automatiquement

### **❌ "Clé API invalide"**  
→ Vérifiez sur [platform.openai.com/api-keys](https://platform.openai.com/api-keys) et relancez `3_CONFIGURER-CLE-API.bat`

### **❌ "Erreur de transcription"**
→ Vérifiez la taille du fichier (< 25MB) et votre connexion internet

### **❌ "Application ne se lance pas"**
→ Relancez `1_INSTALLER.bat` pour une réparation automatique

**💡 Problème persistant ?** Consultez les [Issues GitHub](https://github.com/VotreUsername/Vled-Transcriptor/issues) ou créez une nouvelle issue.

---

## 🗑️ Désinstallation

**Simple et propre :**
- Double-cliquez sur `4_DESINSTALLER.bat`
- Choisissez le niveau de nettoyage :
  - 🧹 Léger (garde vos transcriptions)  
  - 🗑️ Complet (supprime tout)
  - 💾 Sauvegarde + suppression

---

## 🚀 Mises à jour

**Pour les mises à jour :**
1. **Téléchargez** la nouvelle version (même lien)
2. **Extrayez** dans un nouveau dossier  
3. **Copiez** votre dossier `config/` (pour garder votre clé API)
4. **Relancez** `1_INSTALLER.bat`

**Vos transcriptions** dans `exports/` restent intactes !

---

## 📊 Statistiques

![GitHub stars](https://img.shields.io/github/stars/VotreUsername/Vled-Transcriptor?style=social)
![GitHub downloads](https://img.shields.io/github/downloads/VotreUsername/Vled-Transcriptor/total)
![GitHub issues](https://img.shields.io/github/issues/VotreUsername/Vled-Transcriptor)

---

## 🤝 Support et communauté

- **🐛 Bug ?** → [Créer une Issue](https://github.com/VotreUsername/Vled-Transcriptor/issues)
- **💡 Suggestion ?** → [Discussions GitHub](https://github.com/VotreUsername/Vled-Transcriptor/discussions)  
- **❓ Question ?** → Consultez la [documentation complète](https://github.com/VotreUsername/Vled-Transcriptor/wiki)

---

## 📄 Licence et crédits

**📜 Licence :** MIT - Utilisable librement pour tous projets

**🙏 Remerciements :**
- [OpenAI](https://openai.com/) pour Whisper et ChatGPT
- [Streamlit](https://streamlit.io/) pour le framework web
- La communauté Python pour les excellentes bibliothèques

---

## 👨‍💻 Auteur

**Votre Nom** - *Créateur de Vled Transcriptor*

- 🌐 GitHub: [@VotreUsername](https://github.com/VotreUsername)
- 📧 Contact: votre.email@example.com

---

<div align="center">

## 🎤 **TRANSFORMEZ VOS IDÉES EN TEXTE AVEC L'IA !** 🎤

**[📥 TÉLÉCHARGER MAINTENANT](https://github.com/VotreUsername/Vled-Transcriptor/archive/refs/heads/main.zip)**

*Installation automatique • Interface moderne • Résultats professionnels*

⭐ **N'oubliez pas de donner une étoile si vous aimez le projet !** ⭐

</div>

## 📁 Structure du projet

```
Vled-Transcriptor/
├── 🚀 1_INSTALLER.bat           # Installation automatique
├── ▶️  2_LANCER.bat              # Lancement de l'application
├── 🔑 3_CONFIGURER-CLE-API.bat  # Configuration API OpenAI
├── 🗑️ 4_DESINSTALLER.bat        # Désinstallation propre
├── 📄 transcripteur_pro.py      # Code principal de l'application
├── 📄 config_api.py             # Gestionnaire d'API sécurisé
├── 📦 requirements.txt          # Dépendances Python
├── 📖 README.md                 # Cette documentation
├── 📂 temp/                     # Fichiers temporaires (auto-nettoyé)
├── 📂 exports/                  # Vos transcriptions sauvegardées
├── 📂 config/                   # Configuration utilisateur
└── 📂 docs/                     # Documentation additionnelle
```

## 🎯 Guide d'utilisation

### Première utilisation

1. **Lancez** `2_LANCER.bat`
2. **Configurez** votre clé API si demandé
3. **Uploadez** vos fichiers audio (glisser-déposer)
4. **Choisissez** vos options (langue, résumés)
5. **Cliquez** sur "Transcrire"
6. **Récupérez** vos résultats dans l'interface ou le dossier `exports/`

### Formats audio supportés

- 🎵 **Audio** : MP3, WAV, FLAC, M4A, OGG
- 🎬 **Vidéo** : MP4, WEBM (extraction audio automatique)
- 📏 **Taille max** : 25 MB par fichier (configurable)

### Types de résumés disponibles

- 📄 **Résumé bref** : 2-3 phrases essentielles
- 🔹 **Points clés** : Structure en puces hiérarchisées  
- 📋 **Analyse complète** : Bilan détaillé et organisé

## 💰 Coûts d'utilisation

Les tarifs OpenAI sont très abordables :

- 🎤 **Transcription** : ~0,006$ par minute d'audio
- 🤖 **Résumé** : ~0,002$ par résumé généré
- 📊 **Exemple** : 1 heure d'audio ≈ 0,40$ total

OpenAI offre des crédits gratuits pour commencer ! 🎁

## 🔧 Configuration avancée

### Paramètres disponibles

- 🌍 **Langue** : Auto-détection ou spécifique (français, anglais, etc.)
- 🔄 **Fichiers simultanés** : Traitement parallèle (1-5 fichiers)
- 💾 **Export automatique** : Sauvegarde auto dans `exports/`
- 📏 **Taille limite** : Limite de fichier personnalisable

### Fichiers de configuration

- `config/settings.json` : Préférences utilisateur
- `config/api_key.env` : Clé API OpenAI (chiffrée)

## 🛠️ Développement

### Installation manuelle

```bash
# Cloner le projet
git clone https://github.com/votreusername/vled-transcriptor.git
cd vled-transcriptor

# Installer les dépendances
pip install -r requirements.txt

# Configurer la clé API
echo "OPENAI_API_KEY=your-key-here" > config/api_key.env

# Lancer l'application
streamlit run transcripteur_pro.py
```

### Dépendances principales

- `streamlit` : Interface web moderne
- `openai` : API OpenAI (Whisper + ChatGPT)
- `python-dotenv` : Gestion des variables d'environnement
- `psutil` : Monitoring système
- `watchdog` : Surveillance de fichiers

## 🔒 Sécurité et confidentialité

- ✅ **Clés API** stockées localement et chiffrées
- ✅ **Aucune donnée** partagée avec des tiers
- ✅ **Traitement local** (sauf API OpenAI)
- ✅ **Contrôle total** de vos fichiers et transcriptions
- ✅ **Code open source** pour transparence complète

## 📝 Dépannage

### Problèmes courants

**❌ "Python non détecté"**
- Installez Python depuis [python.org](https://www.python.org/downloads/)
- ⚠️ Cochez "Add Python to PATH" lors de l'installation

**❌ "Clé API invalide"**
- Vérifiez votre clé sur [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
- Assurez-vous d'avoir ajouté un moyen de paiement

**❌ "Erreur de transcription"**
- Vérifiez la taille du fichier (< 25MB)
- Testez avec un fichier audio plus court
- Vérifiez votre connexion internet

**❌ "Bibliothèques manquantes"**
- Relancez `1_INSTALLER.bat`
- Vérifiez que pip est à jour

### Logs et débogage

- Les erreurs s'affichent dans l'interface web
- Les fichiers temporaires sont dans `temp/`
- La configuration est dans `config/`

## 🤝 Contribution

Les contributions sont les bienvenues ! 

1. **Fork** le projet
2. **Créez** votre branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. **Commitez** vos changements (`git commit -am 'Ajout d'une nouvelle fonctionnalité'`)
4. **Push** vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. **Ouvrez** une Pull Request

## 📋 Roadmap

- [ ] Support Linux et macOS
- [ ] Interface mobile responsive  
- [ ] Traitement par lots avancé
- [ ] Support de plus de formats audio
- [ ] Intégration avec services cloud
- [ ] Mode hors ligne (Whisper local)
- [ ] API REST pour intégrations

## 📄 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👨‍💻 Auteur

**Votre Nom** - *Développeur principal*

- GitHub: [@votreusername](https://github.com/votreusername)
- Email: votre.email@example.com

## 🙏 Remerciements

- [OpenAI](https://openai.com/) pour Whisper et ChatGPT
- [Streamlit](https://streamlit.io/) pour le framework web
- La communauté Python pour les bibliothèques excellentes
- Tous les contributeurs et utilisateurs !

## 📊 Statistiques

![GitHub stars](https://img.shields.io/github/stars/votreusername/vled-transcriptor?style=social)
![GitHub forks](https://img.shields.io/github/forks/votreusername/vled-transcriptor?style=social)
![GitHub issues](https://img.shields.io/github/issues/votreusername/vled-transcriptor)

---

<div align="center">

**🎤 Vled Transcriptor - Transformez vos idées en texte ! 🎤**

Made with ❤️ by [Votre Nom]

</div>