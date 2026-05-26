# FlashMind Backend

Backend profesional para la aplicación FlashMind, construido con Flask y SQLAlchemy sobre una base de datos SQLite existente.

## Requisitos

- Python 3.10+
- Pip

## Instalación

1. Navega a la carpeta del proyecto:
   ```bash
   cd flashmind-backend
   ```

2. Crea un entorno virtual:
   ```bash
   python -m venv venv
   ```

3. Activa el entorno virtual:
   - Windows: `venv\Scripts\activate`
   - Linux/Mac: `source venv/bin/activate`

4. Instala las dependencias:
   ```bash
   pip install -r requirements.txt
   ```

## Configuración

Asegúrate de que el archivo `.env` tenga la ruta correcta a tu base de datos. Por defecto está configurado para buscar `fichas_educativas.db` en el directorio superior.

```env
FLASK_APP=run.py
FLASK_ENV=development
DATABASE_URL=sqlite:///../fichas_educativas.db
JWT_SECRET_KEY=tu_clave_secreta_aqui
PORT=5000
```

## Migraciones

Para inicializar el sistema de migraciones (Flask-Migrate):

```bash
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

*Nota: Como las tablas ya existen en SQLite, la primera migración detectará que no hay cambios o intentará crearlas. Si ya existen, simplemente asegúrate de que el estado de la migración esté sincronizado.*

## Ejecución

Para iniciar el servidor de desarrollo:

```bash
python run.py
```

El servidor estará disponible en `http://localhost:5000`.

## Estructura del Proyecto

- `app/`: Directorio principal de la aplicación.
  - `models/`: Modelos de SQLAlchemy basados en la estructura SQLite.
  - `routes/`: Blueprints para organizar las rutas (Auth, Themes, etc.).
  - `extensions.py`: Inicialización de extensiones (DB, JWT, Migrate).
  - `config.py`: Configuración de la aplicación.
- `run.py`: Punto de entrada de la aplicación.
- `.env`: Variables de entorno.
- `requirements.txt`: Dependencias del proyecto.
