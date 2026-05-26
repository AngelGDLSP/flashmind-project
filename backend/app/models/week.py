from datetime import datetime
from app.extensions import db

class Week(db.Model):
    __tablename__ = 'semanas'
    
    id_semana = db.Column(db.Integer, primary_key=True)
    nombre_semana = db.Column(db.String(100))
    fecha_inicio = db.Column(db.Date, nullable=False)
    fecha_fin = db.Column(db.Date, nullable=False)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuarios.id_usuario', ondelete='CASCADE'), nullable=False)

    # Relationships
    semana_fichas = db.relationship('WeekFlashcard', backref='week', lazy=True)

    def to_dict(self):
        return {
            "id_semana": self.id_semana,
            "nombre_semana": self.nombre_semana,
            "fecha_inicio": self.fecha_inicio.isoformat(),
            "fecha_fin": self.fecha_fin.isoformat(),
            "id_usuario": self.id_usuario
        }

class WeekFlashcard(db.Model):
    __tablename__ = 'semana_ficha'
    
    id_semana_ficha = db.Column(db.Integer, primary_key=True)
    id_semana = db.Column(db.Integer, db.ForeignKey('semanas.id_semana', ondelete='CASCADE'), nullable=False)
    id_ficha = db.Column(db.Integer, db.ForeignKey('fichas.id_ficha', ondelete='CASCADE'), nullable=False)
    completada = db.Column(db.Integer, default=0)
    fecha_agregada = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            "id_semana_ficha": self.id_semana_ficha,
            "id_semana": self.id_semana,
            "id_ficha": self.id_ficha,
            "completada": bool(self.completada),
            "fecha_agregada": self.fecha_agregada.isoformat()
        }
