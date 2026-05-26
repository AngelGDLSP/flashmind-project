from datetime import datetime
from app.extensions import db

class StudySession(db.Model):
    __tablename__ = 'sesiones_estudio'
    
    id_sesion = db.Column(db.Integer, primary_key=True)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuarios.id_usuario', ondelete='CASCADE'), nullable=False)
    fecha_inicio = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    fecha_fin = db.Column(db.DateTime)
    total_fichas = db.Column(db.Integer, default=0)

    def to_dict(self):
        return {
            "id_sesion": self.id_sesion,
            "id_usuario": self.id_usuario,
            "fecha_inicio": self.fecha_inicio.isoformat(),
            "fecha_fin": self.fecha_fin.isoformat() if self.fecha_fin else None,
            "total_fichas": self.total_fichas
        }
