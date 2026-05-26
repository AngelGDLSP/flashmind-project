from datetime import datetime
from app.extensions import db

class Favorite(db.Model):
    __tablename__ = 'favoritos'
    
    id_favorito = db.Column(db.Integer, primary_key=True)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuarios.id_usuario', ondelete='CASCADE'), nullable=False)
    id_ficha = db.Column(db.Integer, db.ForeignKey('fichas.id_ficha', ondelete='CASCADE'), nullable=False)
    fecha_guardado = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            "id_favorito": self.id_favorito,
            "id_usuario": self.id_usuario,
            "id_ficha": self.id_ficha,
            "fecha_guardado": self.fecha_guardado.isoformat()
        }
