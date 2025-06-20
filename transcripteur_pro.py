"""
🎤 TRANSCRIPTEUR AUDIO PRO
Application Streamlit optimisée pour la transcription audio avec IA

Fonctionnalités :
- Transcription multi-fichiers avec Whisper
- Résumés automatiques avec ChatGPT
- Interface moderne et intuitive
- Export automatique
- Configuration sécurisée
"""

import streamlit as st
import tempfile
import os
import json
import time
from pathlib import Path
from datetime import datetime
import zipfile
from io import BytesIO
from concurrent.futures import ThreadPoolExecutor, as_completed
import psutil

# Import de notre gestionnaire d'API sécurisé
from config_api import get_openai_client

# Configuration de la page
st.set_page_config(
    page_title="🎤 Transcripteur Audio PRO",
    page_icon="🎤",
    layout="wide",
    initial_sidebar_state="expanded"
)

# CSS personnalisé pour une interface moderne
st.markdown("""
<style>
    .main-header {
        text-align: center;
        padding: 1rem;
        background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 10px;
        margin-bottom: 2rem;
    }
    
    .metric-card {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 10px;
        border-left: 4px solid #667eea;
    }
    
    .success-card {
        background: #d4edda;
        border: 1px solid #c3e6cb;
        padding: 1rem;
        border-radius: 5px;
        margin: 1rem 0;
    }
    
    .warning-card {
        background: #fff3cd;
        border: 1px solid #ffeaa7;
        padding: 1rem;
        border-radius: 5px;
        margin: 1rem 0;
    }
</style>
""", unsafe_allow_html=True)

# Configuration des dossiers
TEMP_DIR = Path("temp")
EXPORTS_DIR = Path("exports")
CONFIG_DIR = Path("config")

# Créer les dossiers s'ils n'existent pas
for dir_path in [TEMP_DIR, EXPORTS_DIR, CONFIG_DIR]:
    dir_path.mkdir(exist_ok=True)

# Prompts optimisés pour les résumés
PROMPTS = {
    "brief": """Fais un résumé très bref de cette transcription en 2-3 phrases maximum. 
    Va à l'essentiel et capture l'idée principale.
    
    Transcription à résumer :""",
    
    "points": """Fais un résumé de cette transcription sous forme de points clés bien structurés.
    Utilise des puces et organise les informations de manière claire et hiérarchique.
    Mets en avant les éléments les plus importants.
    
    Transcription à résumer :""",
    
    "complete": """Fais un bilan complet et bien organisé de cette transcription.
    Structure ton analyse avec :
    - Un résumé général
    - Les points principaux développés
    - Les détails importants
    - Une conclusion/synthèse
    
    Sois précis, organisé et complet dans ton analyse.
    
    Transcription à résumer :"""
}

class TranscripteurPro:
    def __init__(self):
        self.client = None
        self.setup_client()
        self.load_settings()
    
    def setup_client(self):
        """Initialise le client OpenAI de manière sécurisée"""
        self.client = get_openai_client()
    
    def load_settings(self):
        """Charge les paramètres utilisateur"""
        settings_file = CONFIG_DIR / "settings.json"
        default_settings = {
            "language": "auto",
            "summary_types": ["brief"],
            "auto_export": True,
            "max_file_size_mb": 25,
            "concurrent_files": 3
        }
        
        if settings_file.exists():
            try:
                with open(settings_file, "r", encoding="utf-8") as f:
                    self.settings = json.load(f)
            except:
                self.settings = default_settings
        else:
            self.settings = default_settings
            self.save_settings()
    
    def save_settings(self):
        """Sauvegarde les paramètres utilisateur"""
        settings_file = CONFIG_DIR / "settings.json"
        with open(settings_file, "w", encoding="utf-8") as f:
            json.dump(self.settings, f, indent=2)
    
    @st.cache_data
    def transcribe_audio(_self, audio_content, filename, language=None):
        """Transcrit un fichier audio avec cache pour éviter les re-calculs"""
        if not _self.client:
            return None, "Client OpenAI non configuré"
        
        try:
            # Créer un fichier temporaire
            suffix = Path(filename).suffix
            with tempfile.NamedTemporaryFile(delete=False, suffix=suffix, dir=TEMP_DIR) as tmp_file:
                tmp_file.write(audio_content)
                tmp_file_path = tmp_file.name
            
            # Transcription avec OpenAI
            with open(tmp_file_path, "rb") as audio:
                if language and language != "auto":
                    transcript = _self.client.audio.transcriptions.create(
                        model="whisper-1",
                        file=audio,
                        language=language
                    )
                else:
                    transcript = _self.client.audio.transcriptions.create(
                        model="whisper-1",
                        file=audio
                    )
            
            # Nettoyer le fichier temporaire
            os.unlink(tmp_file_path)
            
            return transcript.text, None
        
        except Exception as e:
            # Nettoyer le fichier temporaire en cas d'erreur
            if 'tmp_file_path' in locals():
                try:
                    os.unlink(tmp_file_path)
                except:
                    pass
            return None, str(e)
    
    def generate_summary(self, transcript, summary_type):
        """Génère un résumé de la transcription"""
        if not self.client:
            return "Client OpenAI non configuré"
        
        try:
            prompt = PROMPTS[summary_type] + "\n\n" + transcript
            
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "user", "content": prompt}
                ],
                max_tokens=1000,
                temperature=0.7
            )
            
            return response.choices[0].message.content
        
        except Exception as e:
            return f"Erreur lors de la génération du résumé : {str(e)}"
    
    def process_files_parallel(self, uploaded_files, language, progress_callback=None):
        """Traite plusieurs fichiers en parallèle pour optimiser les performances"""
        transcriptions = {}
        errors = []
        
        def process_single_file(file_data):
            filename, content = file_data
            transcript, error = self.transcribe_audio(content, filename, language)
            return filename, transcript, error
        
        # Préparer les données des fichiers
        file_data = [(file.name, file.getvalue()) for file in uploaded_files]
        
        # Traitement en parallèle
        max_workers = min(self.settings["concurrent_files"], len(file_data))
        
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Soumettre tous les jobs
            future_to_file = {
                executor.submit(process_single_file, data): data[0] 
                for data in file_data
            }
            
            # Collecter les résultats
            completed = 0
            for future in as_completed(future_to_file):
                filename = future_to_file[future]
                try:
                    result_filename, transcript, error = future.result()
                    if transcript:
                        transcriptions[result_filename] = transcript
                    else:
                        errors.append(f"❌ {result_filename}: {error}")
                except Exception as e:
                    errors.append(f"❌ {filename}: {str(e)}")
                
                completed += 1
                if progress_callback:
                    progress_callback(completed / len(file_data))
        
        return transcriptions, errors
    
    def auto_export(self, transcriptions, summaries=None):
        """Export automatique des transcriptions"""
        if not self.settings["auto_export"]:
            return None
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        export_dir = EXPORTS_DIR / f"export_{timestamp}"
        export_dir.mkdir(exist_ok=True)
        
        # Exporter les transcriptions
        for filename, transcript in transcriptions.items():
            base_name = Path(filename).stem
            output_file = export_dir / f"{base_name}.txt"
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(transcript)
        
        # Exporter les résumés si disponibles
        if summaries:
            for filename, file_summaries in summaries.items():
                base_name = Path(filename).stem
                for summary_type, summary in file_summaries.items():
                    output_file = export_dir / f"{base_name}_{summary_type}.txt"
                    with open(output_file, "w", encoding="utf-8") as f:
                        f.write(summary)
        
        return export_dir

def main():
    """Fonction principale de l'application"""
    
    # En-tête moderne
    st.markdown("""
    <div class="main-header">
        <h1>🎤 TRANSCRIPTEUR AUDIO PRO</h1>
        <p>Transcription intelligente avec IA • Interface optimisée • Export automatique</p>
    </div>
    """, unsafe_allow_html=True)
    
    # Initialiser l'application
    app = TranscripteurPro()
    
    # Vérifier si le client OpenAI est configuré
    if not app.client:
        st.stop()  # L'interface de configuration est gérée par config_api.py
    
    # Sidebar avec paramètres
    with st.sidebar:
        st.header("⚙️ Paramètres")
        
        # Langue de transcription
        language = st.selectbox(
            "🌍 Langue",
            options=["auto", "fr", "en", "es", "de", "it", "pt", "ru", "ja", "ko"],
            index=0 if app.settings["language"] == "auto" else ["auto", "fr", "en", "es", "de", "it", "pt", "ru", "ja", "ko"].index(app.settings["language"]),
            format_func=lambda x: {
                "auto": "🔍 Auto-détection",
                "fr": "🇫🇷 Français", "en": "🇺🇸 Anglais", "es": "🇪🇸 Espagnol", 
                "de": "🇩🇪 Allemand", "it": "🇮🇹 Italien", "pt": "🇵🇹 Portugais",
                "ru": "🇷🇺 Russe", "ja": "🇯🇵 Japonais", "ko": "🇰🇷 Coréen"
            }.get(x, x)
        )
        
        st.markdown("---")
        
        # Options de résumé
        st.subheader("📝 Résumés automatiques")
        generate_summaries = st.checkbox("Activer les résumés", value=True)
        
        if generate_summaries:
            summary_types = st.multiselect(
                "Types de résumés :",
                options=["brief", "points", "complete"],
                default=app.settings["summary_types"],
                format_func=lambda x: {
                    "brief": "📄 Résumé bref",
                    "points": "🔹 Points clés", 
                    "complete": "📋 Analyse complète"
                }[x]
            )
        else:
            summary_types = []
        
        st.markdown("---")
        
        # Options avancées
        st.subheader("🔧 Options avancées")
        
        merge_transcripts = st.checkbox("Fusionner les transcriptions", value=False)
        
        auto_export = st.checkbox(
            "Export automatique", 
            value=app.settings["auto_export"],
            help="Sauvegarde automatique dans le dossier 'exports'"
        )
        
        max_concurrent = st.slider(
            "Fichiers simultanés",
            min_value=1,
            max_value=5,
            value=app.settings["concurrent_files"],
            help="Nombre de fichiers traités en parallèle"
        )
        
        # Sauvegarder les paramètres si changés
        if (language != app.settings["language"] or 
            summary_types != app.settings["summary_types"] or
            auto_export != app.settings["auto_export"] or
            max_concurrent != app.settings["concurrent_files"]):
            
            app.settings.update({
                "language": language,
                "summary_types": summary_types,
                "auto_export": auto_export,
                "concurrent_files": max_concurrent
            })
            app.save_settings()
        
        # Informations système
        st.markdown("---")
        st.subheader("📊 Système")
        
        # Utilisation mémoire
        memory_percent = psutil.virtual_memory().percent
        st.metric("RAM", f"{memory_percent:.1f}%")
        
        # Espace disque
        disk_usage = psutil.disk_usage('.')
        disk_percent = (disk_usage.used / disk_usage.total) * 100
        st.metric("Disque", f"{disk_percent:.1f}%")
    
    # Interface principale
    col1, col2 = st.columns([2, 1])
    
    with col1:
        st.subheader("📁 Upload de fichiers")
        
        uploaded_files = st.file_uploader(
            "Choisissez un ou plusieurs fichiers audio",
            type=['mp3', 'wav', 'flac', 'm4a', 'mp4', 'mpeg', 'mpga', 'oga', 'ogg', 'webm'],
            help="Glissez-déposez vos fichiers ici ou cliquez pour parcourir",
            accept_multiple_files=True
        )
    
    with col2:
        if uploaded_files:
            st.subheader("📋 Récapitulatif")
            
            total_size = sum(file.size for file in uploaded_files)
            st.metric("Fichiers", len(uploaded_files))
            st.metric("Taille totale", f"{total_size / 1024 / 1024:.1f} MB")
            
            # Estimation du temps
            estimated_minutes = len(uploaded_files) * 0.5  # Estimation rough
            st.metric("Temps estimé", f"~{estimated_minutes:.1f} min")
    
    # Traitement des fichiers
    if uploaded_files:
        # Validation des fichiers
        valid_files = []
        warnings = []
        
        for file in uploaded_files:
            file_size_mb = file.size / 1024 / 1024
            if file_size_mb > app.settings["max_file_size_mb"]:
                warnings.append(f"⚠️ {file.name}: {file_size_mb:.1f}MB (limite: {app.settings['max_file_size_mb']}MB)")
            else:
                valid_files.append(file)
        
        # Afficher les avertissements
        if warnings:
            st.warning("\n".join(warnings))
        
        # Afficher les fichiers valides
        if valid_files:
            with st.expander(f"📂 Fichiers à traiter ({len(valid_files)})", expanded=True):
                for i, file in enumerate(valid_files, 1):
                    col1, col2, col3 = st.columns([3, 1, 1])
                    with col1:
                        st.text(f"{i}. {file.name}")
                    with col2:
                        st.text(f"{file.size / 1024 / 1024:.1f} MB")
                    with col3:
                        # Aperçu audio
                        st.audio(file, format='audio/wav', start_time=0)
            
            # Bouton de traitement principal
            col1, col2, col3 = st.columns([1, 2, 1])
            with col2:
                process_button = st.button(
                    f"🚀 TRANSCRIRE {len(valid_files)} FICHIER(S)",
                    type="primary",
                    use_container_width=True
                )
            
            # Traitement
            if process_button:
                start_time = time.time()
                
                # Conteneurs pour l'affichage en temps réel
                status_container = st.container()
                progress_container = st.container()
                results_container = st.container()
                
                with status_container:
                    st.info("🔄 **Traitement en cours...**")
                
                with progress_container:
                    progress_bar = st.progress(0)
                    status_text = st.empty()
                
                # Fonction de callback pour la progression
                def update_progress(progress):
                    progress_bar.progress(progress)
                    status_text.text(f"Progression: {progress:.0%}")
                
                # Traitement des fichiers
                try:
                    with st.spinner("🎤 Transcription en cours..."):
                        transcriptions, errors = app.process_files_parallel(
                            valid_files, 
                            language,
                            update_progress
                        )
                    
                    # Génération des résumés
                    summaries = {}
                    if generate_summaries and summary_types and transcriptions:
                        with st.spinner("🤖 Génération des résumés..."):
                            total_summaries = len(transcriptions) * len(summary_types)
                            current_summary = 0
                            
                            for filename, transcript in transcriptions.items():
                                file_summaries = {}
                                for summary_type in summary_types:
                                    summary = app.generate_summary(transcript, summary_type)
                                    file_summaries[summary_type] = summary
                                    current_summary += 1
                                    progress_bar.progress(current_summary / total_summaries)
                                summaries[filename] = file_summaries
                    
                    # Export automatique
                    export_dir = None
                    if auto_export and transcriptions:
                        export_dir = app.auto_export(transcriptions, summaries)
                    
                    # Effacer les indicateurs de progression
                    progress_container.empty()
                    
                    # Affichage des résultats
                    with results_container:
                        end_time = time.time()
                        processing_time = end_time - start_time
                        
                        if transcriptions:
                            st.success(f"✅ **{len(transcriptions)} fichier(s) transcrit(s) avec succès !**")
                            st.info(f"⏱️ Temps de traitement: {processing_time:.1f} secondes")
                            
                            # Afficher les erreurs s'il y en a
                            if errors:
                                with st.expander("⚠️ Erreurs rencontrées", expanded=False):
                                    for error in errors:
                                        st.error(error)
                            
                            # Export automatique info
                            if export_dir:
                                st.success(f"💾 **Export automatique:** `{export_dir}`")
                            
                            # Affichage des résultats
                            if merge_transcripts:
                                display_merged_results(transcriptions, summaries, summary_types, app)
                            else:
                                display_separate_results(transcriptions, summaries, summary_types)
                            
                            # Options de téléchargement
                            display_download_options(transcriptions, summaries)
                        
                        else:
                            st.error("❌ **Aucun fichier n'a pu être transcrit.**")
                            for error in errors:
                                st.error(error)
                
                except Exception as e:
                    progress_container.empty()
                    st.error(f"❌ **Erreur lors du traitement:** {str(e)}")
        
        else:
            st.warning("⚠️ Aucun fichier valide à traiter.")

def display_merged_results(transcriptions, summaries, summary_types, app):
    """Affiche les résultats fusionnés"""
    st.markdown("---")
    st.subheader("📝 Transcription fusionnée")
    
    # Fusion des transcriptions
    merged_transcript = "\n\n" + "="*50 + "\n\n".join([
        f"📄 **{filename}**\n\n{content}" 
        for filename, content in transcriptions.items()
    ])
    
    # Affichage avec possibilité d'édition
    edited_transcript = st.text_area(
        "Transcription complète (éditable):",
        value=merged_transcript,
        height=400,
        key="merged_transcript"
    )
    
    # Résumés de la transcription fusionnée
    if summaries and summary_types:
        st.markdown("---")
        st.subheader("🤖 Résumés de la transcription fusionnée")
        
        summary_tabs = st.tabs([{
            "brief": "📄 Résumé bref",
            "points": "🔹 Points clés",
            "complete": "📋 Analyse complète"
        }[stype] for stype in summary_types])
        
        for tab, summary_type in zip(summary_tabs, summary_types):
            with tab:
                with st.spinner(f"Génération du résumé {summary_type}..."):
                    global_summary = app.generate_summary(edited_transcript, summary_type)
                
                st.markdown(global_summary)
                
                # Bouton de téléchargement pour chaque résumé
                st.download_button(
                    label="💾 Télécharger ce résumé",
                    data=global_summary,
                    file_name=f"resume_global_{summary_type}_{datetime.now().strftime('%Y%m%d_%H%M')}.txt",
                    mime="text/plain",
                    key=f"download_global_{summary_type}"
                )

def display_separate_results(transcriptions, summaries, summary_types):
    """Affiche les résultats séparés par fichier"""
    st.markdown("---")
    st.subheader("📄 Résultats par fichier")
    
    # Tabs pour chaque fichier
    tab_names = [f"📄 {Path(filename).stem}" for filename in transcriptions.keys()]
    tabs = st.tabs(tab_names)
    
    for tab, (filename, transcript) in zip(tabs, transcriptions.items()):
        with tab:
            # Affichage de la transcription
            st.markdown(f"**📁 Fichier:** `{filename}`")
            
            edited_transcript = st.text_area(
                "Transcription (éditable):",
                value=transcript,
                height=300,
                key=f"transcript_{filename}"
            )
            
            # Métriques du fichier
            col1, col2, col3 = st.columns(3)
            with col1:
                st.metric("Mots", len(transcript.split()))
            with col2:
                st.metric("Caractères", len(transcript))
            with col3:
                # Estimation du temps de lecture
                reading_time = len(transcript.split()) / 200  # 200 mots/min
                st.metric("Lecture", f"{reading_time:.1f} min")
            
            # Boutons d'action
            col1, col2 = st.columns(2)
            with col1:
                st.download_button(
                    label="💾 Télécharger la transcription",
                    data=edited_transcript,
                    file_name=f"transcription_{Path(filename).stem}_{datetime.now().strftime('%Y%m%d_%H%M')}.txt",
                    mime="text/plain",
                    key=f"download_transcript_{filename}",
                    use_container_width=True
                )
            
            with col2:
                if st.button(f"🔄 Regénérer les résumés", key=f"regen_{filename}", use_container_width=True):
                    st.rerun()
            
            # Résumés individuels
            if filename in summaries:
                st.markdown("---")
                st.markdown("### 🤖 Résumés automatiques")
                
                summary_tabs_individual = st.tabs([{
                    "brief": "📄 Bref",
                    "points": "🔹 Points clés",
                    "complete": "📋 Complet"
                }[stype] for stype in summary_types if stype in summaries[filename]])
                
                for tab_summary, summary_type in zip(summary_tabs_individual, 
                                                   [st for st in summary_types if st in summaries[filename]]):
                    with tab_summary:
                        summary_content = summaries[filename][summary_type]
                        
                        # Affichage du résumé avec possibilité d'édition
                        edited_summary = st.text_area(
                            f"Résumé {summary_type} (éditable):",
                            value=summary_content,
                            height=200,
                            key=f"summary_{filename}_{summary_type}"
                        )
                        
                        # Téléchargement du résumé
                        st.download_button(
                            label="💾 Télécharger ce résumé",
                            data=edited_summary,
                            file_name=f"resume_{Path(filename).stem}_{summary_type}_{datetime.now().strftime('%Y%m%d_%H%M')}.txt",
                            mime="text/plain",
                            key=f"download_summary_{filename}_{summary_type}"
                        )

def display_download_options(transcriptions, summaries):
    """Affiche les options de téléchargement groupé"""
    st.markdown("---")
    st.subheader("📦 Téléchargements groupés")
    
    col1, col2 = st.columns(2)
    
    with col1:
        # ZIP de toutes les transcriptions
        all_transcripts = {}
        for filename, transcript in transcriptions.items():
            base_name = Path(filename).stem
            all_transcripts[f"transcriptions/{base_name}.txt"] = transcript
        
        zip_transcripts = create_zip_file(all_transcripts)
        st.download_button(
            label="📄 Télécharger toutes les transcriptions (ZIP)",
            data=zip_transcripts.getvalue(),
            file_name=f"transcriptions_{datetime.now().strftime('%Y%m%d_%H%M')}.zip",
            mime="application/zip",
            use_container_width=True
        )
    
    with col2:
        # ZIP complet (transcriptions + résumés)
        if summaries:
            all_files = {}
            
            # Ajouter les transcriptions
            for filename, transcript in transcriptions.items():
                base_name = Path(filename).stem
                all_files[f"transcriptions/{base_name}.txt"] = transcript
            
            # Ajouter les résumés
            for filename, file_summaries in summaries.items():
                base_name = Path(filename).stem
                for summary_type, summary in file_summaries.items():
                    all_files[f"resumes/{base_name}_{summary_type}.txt"] = summary
            
            zip_complete = create_zip_file(all_files)
            st.download_button(
                label="📦 Télécharger TOUT (ZIP complet)",
                data=zip_complete.getvalue(),
                file_name=f"transcription_complete_{datetime.now().strftime('%Y%m%d_%H%M')}.zip",
                mime="application/zip",
                use_container_width=True
            )

def create_zip_file(file_dict):
    """Crée un fichier ZIP à partir d'un dictionnaire de fichiers"""
    zip_buffer = BytesIO()
    with zipfile.ZipFile(zip_buffer, 'w', zipfile.ZIP_DEFLATED) as zip_file:
        for filepath, content in file_dict.items():
            zip_file.writestr(filepath, content)
    zip_buffer.seek(0)
    return zip_buffer

# Footer informatif
def show_footer():
    """Affiche le footer avec informations et conseils"""
    st.markdown("---")
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("""
        **ℹ️ Formats supportés**
        - Audio: MP3, WAV, FLAC, M4A
        - Vidéo: MP4, WEBM
        - Taille max: 25MB/fichier
        """)
    
    with col2:
        st.markdown("""
        **🚀 Optimisations**
        - Traitement parallèle
        - Cache intelligent
        - Export automatique
        """)
    
    with col3:
        st.markdown("""
        **🔧 Raccourcis**
        - F5: Actualiser
        - Ctrl+S: Sauvegarder
        - Esc: Annuler
        """)
    
    st.markdown("""
    <div style='text-align: center; color: #666; margin-top: 2rem;'>
        🎤 <strong>Transcripteur Audio PRO</strong> • Powered by OpenAI Whisper & ChatGPT<br>
        Made with ❤️ for professionals • Version 2.0
    </div>
    """, unsafe_allow_html=True)

if __name__ == "__main__":
    main()
    show_footer()