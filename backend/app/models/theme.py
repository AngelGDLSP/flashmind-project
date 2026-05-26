from datetime import datetime
from app.extensions import db

class Theme(db.Model):
    __tablename__ = 'temas'
    
    id_tema = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    descripcion = db.Column(db.Text)
    id_categoria = db.Column(db.Integer, db.ForeignKey('categorias.id_categoria', ondelete='CASCADE'), nullable=False)
    id_usuario = db.Column(db.Integer, db.ForeignKey('usuarios.id_usuario', ondelete='CASCADE'), nullable=False)
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    fichas = db.relationship('Flashcard', backref='theme', lazy=True)

    def to_dict(self):
        return {
            "id_tema": self.id_tema,
            "nombre": self.nombre,
            "descripcion": self.descripcion,
            "id_categoria": self.id_categoria,
            "id_usuario": self.id_usuario,
            "fecha_creacion": self.fecha_creacion.isoformat()
        }
