# config_api.py
import openai
from dotenv import load_dotenv
import os

def get_openai_client():
    load_dotenv("config/api_key.env")
    return openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))