from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.theme import Theme
from app.models.flashcard import Flashcard
from app.extensions import db

themes_bp = Blueprint('themes', __name__)

# ── Themes ────────────────────────────────────────────────────────────────────

@themes_bp.route('/', methods=['GET'])
@jwt_required()
def get_themes():
    user_id = get_jwt_identity()
    themes = Theme.query.filter_by(id_usuario=user_id).all()
    return jsonify([theme.to_dict() for theme in themes]), 200

@themes_bp.route('/', methods=['POST'])
@jwt_required()
def create_theme():
    user_id = get_jwt_identity()
    data = request.get_json()

    new_theme = Theme(
        nombre=data.get('nombre'),
        descripcion=data.get('descripcion'),
        id_categoria=data.get('id_categoria'),
        id_usuario=user_id
    )

    db.session.add(new_theme)
    db.session.commit()

    return jsonify(new_theme.to_dict()), 201

@themes_bp.route('/<int:theme_id>', methods=['DELETE'])
@jwt_required()
def delete_theme(theme_id):
    user_id = get_jwt_identity()
    theme = Theme.query.filter_by(id_tema=theme_id, id_usuario=user_id).first_or_404()
    db.session.delete(theme)
    db.session.commit()
    return jsonify({"msg": "Tema eliminado"}), 200

# ── Flashcards ────────────────────────────────────────────────────────────────

@themes_bp.route('/<int:theme_id>/flashcards', methods=['GET'])
@jwt_required()
def get_flashcards(theme_id):
    user_id = get_jwt_identity()

    # Verificar que el tema pertenece al usuario
    theme = Theme.query.filter_by(id_tema=theme_id, id_usuario=user_id).first_or_404()

    flashcards = Flashcard.query.filter_by(id_tema=theme.id_tema).all()
    return jsonify([f.to_dict() for f in flashcards]), 200

@themes_bp.route('/<int:theme_id>/flashcards', methods=['POST'])
@jwt_required()
def create_flashcard(theme_id):
    user_id = get_jwt_identity()

    # Verificar que el tema pertenece al usuario
    theme = Theme.query.filter_by(id_tema=theme_id, id_usuario=user_id).first_or_404()

    data = request.get_json()

    new_card = Flashcard(
        pregunta=data.get('pregunta'),
        respuesta=data.get('respuesta'),
        dificultad=data.get('dificultad', 'media'),
        ejemplo=data.get('ejemplo'),
        id_tema=theme.id_tema
    )

    db.session.add(new_card)
    db.session.commit()

    return jsonify(new_card.to_dict()), 201

@themes_bp.route('/<int:theme_id>/flashcards/<int:card_id>', methods=['PUT'])
@jwt_required()
def update_flashcard(theme_id, card_id):
    user_id = get_jwt_identity()

    # Verificar que el tema pertenece al usuario
    Theme.query.filter_by(id_tema=theme_id, id_usuario=user_id).first_or_404()

    card = Flashcard.query.filter_by(id_ficha=card_id, id_tema=theme_id).first_or_404()
    data = request.get_json()

    card.pregunta = data.get('pregunta', card.pregunta)
    card.respuesta = data.get('respuesta', card.respuesta)
    card.dificultad = data.get('dificultad', card.dificultad)
    card.interval = data.get('interval', card.interval)
    card.ease_factor = data.get('ease_factor', card.ease_factor)
    card.repetitions = data.get('repetitions', card.repetitions)
    card.veces_repasada = data.get('veces_repasada', card.veces_repasada)

    if data.get('next_review'):
        from datetime import datetime
        card.next_review = datetime.fromisoformat(data['next_review'].replace('Z', ''))

    db.session.commit()
    return jsonify(card.to_dict()), 200

@themes_bp.route('/<int:theme_id>/flashcards/<int:card_id>', methods=['DELETE'])
@jwt_required()
def delete_flashcard(theme_id, card_id):
    user_id = get_jwt_identity()

    Theme.query.filter_by(id_tema=theme_id, id_usuario=user_id).first_or_404()

    card = Flashcard.query.filter_by(id_ficha=card_id, id_tema=theme_id).first_or_404()
    db.session.delete(card)
    db.session.commit()
    return jsonify({"msg": "Flashcard eliminada"}), 200