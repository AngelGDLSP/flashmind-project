from flask import Flask
from app.config import Config
from app.extensions import db, migrate, jwt, cors

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)

    # ✅ FIX: CORS configurado explícitamente para Flutter Web.
    # Sin esto, el preflight OPTIONS que Flutter Web manda antes de cada
    # request es rechazado por Flask, y el request nunca llega al blueprint.
    cors.init_app(app, resources={
        r"/api/*": {
            "origins": "*",                          # En producción pon tu dominio
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"],
            "supports_credentials": False            # True solo si usas cookies
        }
    })

    # Register blueprints
    from app.routes.auth import auth_bp
    from app.routes.themes import themes_bp
    from app.routes.ai import ai_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(themes_bp, url_prefix='/api/themes')
    app.register_blueprint(ai_bp, url_prefix='/api/ai')

    @app.route('/')
    def index():
        return {
            "message": "FlashMind API is running",
            "docs": "/api/docs"
        }, 200

    @app.route('/health')
    def health_check():
        return {
            "status": "ok",
            "project": "FlashMind API",
            "version": "1.0"
        }, 200

    return app