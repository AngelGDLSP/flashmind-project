from datetime import datetime
from app.extensions import db
from werkzeug.security import generate_password_hash, check_password_hash

class User(db.Model):
    __tablename__ = 'usuarios'
    
    id_usuario = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)
    fecha_registro = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    temas = db.relationship('Theme', backref='author', lazy=True)
    semanas = db.relationship('Week', backref='user', lazy=True)
    progreso = db.relationship('Progress', backref='user', lazy=True)
    estadisticas = db.relationship('Statistics', backref='user', lazy=True, uselist=False)
    favoritos = db.relationship('Favorite', backref='user', lazy=True)
    sesiones = db.relationship('StudySession', backref='user', lazy=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            "id_usuario": self.id_usuario,
            "nombre": self.nombre,
            "email": self.email,
            "fecha_registro": self.fecha_registro.isoformat()
        }
