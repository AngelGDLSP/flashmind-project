from datetime import datetime
from app.extensions import db

class Flashcard(db.Model):
    __tablename__ = 'fichas'
    
    id_ficha = db.Column(db.Integer, primary_key=True)
    pregunta = db.Column(db.Text, nullable=False)
    respuesta = db.Column(db.Text, nullable=False)
    dificultad = db.Column(db.String(20), default='media')
    ejemplo = db.Column(db.Text)
    veces_repasada = db.Column(db.Integer, default=0)
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    id_tema = db.Column(db.Integer, db.ForeignKey('temas.id_tema', ondelete='CASCADE'), nullable=False)

    # SRS Fields (Anki-style)
    interval = db.Column(db.Integer, default=0) # Días hasta el siguiente repaso
    ease_factor = db.Column(db.Float, default=2.5) # Factor de facilidad
    repetitions = db.Column(db.Integer, default=0) # Veces acertada consecutivamente
    next_review = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    progreso = db.relationship('Progress', backref='flashcard', lazy=True)
    favoritos = db.relationship('Favorite', backref='flashcard', lazy=True)
    semana_fichas = db.relationship('WeekFlashcard', backref='flashcard', lazy=True)

    def to_dict(self):
        return {
            "id_ficha": self.id_ficha,
            "pregunta": self.pregunta,
            "respuesta": self.respuesta,
            "dificultad": self.dificultad,
            "ejemplo": self.ejemplo,
            "veces_repasada": self.veces_repasada,
            "id_tema": self.id_tema,
            "interval": self.interval,
            "ease_factor": self.ease_factor,
            "repetitions": self.repetitions,
            "next_review": self.next_review.isoformat()
        }
