from datetime import datetime
from app.extensions import db

class Statistics(db.Model):
    __tablename__ = 'estadisticas'
    
    id_estadistica = db.Column(db.Integer, primary_key=True)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuarios.id_usuario', ondelete='CASCADE'), nullable=False)
    fichas_estudiadas = db.Column(db.Integer, default=0)
    aciertos_totales = db.Column(db.Integer, default=0)
    errores_totales = db.Column(db.Integer, default=0)
    racha_dias = db.Column(db.Integer, default=0)
    tiempo_estudio_min = db.Column(db.Integer, default=0)
    ultima_actividad = db.Column(db.DateTime)

    def to_dict(self):
        return {
            "id_estadistica": self.id_estadistica,
            "id_usuario": self.id_usuario,
            "fichas_estudiadas": self.fichas_estudiadas,
            "aciertos_totales": self.aciertos_totales,
            "errores_totales": self.errores_totales,
            "racha_dias": self.racha_dias,
            "tiempo_estudio_min": self.tiempo_estudio_min,
            "ultima_actividad": self.ultima_actividad.isoformat() if self.ultima_actividad else None
        }
