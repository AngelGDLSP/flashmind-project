from datetime import datetime
from app.extensions import db

class Progress(db.Model):
    __tablename__ = 'progreso'
    
    id_progreso = db.Column(db.Integer, primary_key=True)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuarios.id_usuario', ondelete='CASCADE'), nullable=False)
    id_ficha = db.Column(db.Integer, db.ForeignKey('fichas.id_ficha', ondelete='CASCADE'), nullable=False)
    aciertos = db.Column(db.Integer, default=0)
    errores = db.Column(db.Integer, default=0)
    ultima_revision = db.Column(db.DateTime)
    nivel_dominio = db.Column(db.String(20), default='bajo')

    def to_dict(self):
        return {
            "id_progreso": self.id_progreso,
            "id_usuario": self.id_usuario,
            "id_ficha": self.id_ficha,
            "aciertos": self.aciertos,
            "errores": self.errores,
            "ultima_revision": self.ultima_revision.isoformat() if self.ultima_revision else None,
            "nivel_dominio": self.nivel_dominio
        }
