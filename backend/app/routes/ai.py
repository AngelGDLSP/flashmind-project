from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from app.services.ai_service import AIService

ai_bp = Blueprint('ai', __name__)

@ai_bp.route('/generate-flashcards', methods=['POST'])
@jwt_required()
def generate():
    data = request.get_json()
    texto = data.get('texto')
    cantidad = data.get('cantidad', 5)

    if not texto:
        return jsonify({"msg": "Texto es requerido"}), 400

    try:
        flashcards = AIService.generate_flashcards(texto, cantidad)
        return jsonify(flashcards), 200
    except Exception as e:
        return jsonify({"msg": str(e)}), 500
