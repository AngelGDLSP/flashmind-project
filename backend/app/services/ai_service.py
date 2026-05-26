import os
import json

class AIService:
    """
    Capa abstracta para servicios de IA.
    Configurable para usar OpenAI, Gemini o mocks para desarrollo.
    """
    
    @staticmethod
    def generate_flashcards(text, count=5):
        provider = os.getenv('AI_PROVIDER', 'mock')
        
        if provider == 'openai':
            return AIService._use_openai(text, count)
        elif provider == 'gemini':
            return AIService._use_gemini(text, count)
        else:
            return AIService._mock_response(text, count)

    @staticmethod
    def _mock_response(text, count):
        # Simulación de respuesta de IA para desarrollo
        words = text.split()[:10]
        context = " ".join(words)
        return [
            {
                "pregunta": f"¿Qué es {context}... (Ficha {i+1})?",
                "respuesta": f"Esta es una respuesta generada automáticamente para la ficha {i+1} basada en el texto proporcionado."
            } for i in range(count)
        ]

    @staticmethod
    def _use_openai(text, count):
        # Aquí iría la integración real con OpenAI
        pass

    @staticmethod
    def _use_gemini(text, count):
        # Aquí iría la integración real con Google Gemini
        pass
