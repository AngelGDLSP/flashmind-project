# 🚀 FlashMind Project

Aplicación educativa desarrollada con **Flutter (Frontend)** y **Flask (Backend)**, diseñada para gestionar fichas educativas de manera eficiente.

---

## 📁 Estructura del proyecto

```
flashmind-project/
│
├── frontend/   # Aplicación móvil (Flutter)
├── backend/    # API REST (Flask)
└── fichas_educativas  # Base de datos (SQLite)
```

---

## ⚙️ Tecnologías utilizadas

* 📱 Flutter
* 🐍 Python (Flask)
* 🗄️ SQLite
* 🌐 REST API

---

## 🚀 Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/AngelGDLSP/flashmind-project.git
cd flashmind-project
```

---

## 🔧 Backend (Flask)

### 📌 Requisitos:

* Python instalado

### ▶️ Pasos:

```bash
cd backend
pip install flask flask-cors
python app.py
```

🔗 El servidor se ejecutará en:

```
http://127.0.0.1:5000
```

---

## 📱 Frontend (Flutter)

### 📌 Requisitos:

* Flutter SDK
* Android Studio o VS Code
* Emulador o dispositivo físico

### ▶️ Pasos:

```bash
cd frontend
flutter pub get
flutter run
```

---

## ⚠️ Configuración importante

Si ejecutas la app en un **dispositivo físico**, debes cambiar la URL del backend:

```dart
http://127.0.0.1:5000
```

Por la IP local de tu computadora, por ejemplo:

```dart
http://192.168.1.100:5000
```

---

## 🧠 Notas adicionales

* Asegúrate de que el backend esté corriendo antes de iniciar el frontend.
* Verifica que ambos dispositivos estén en la misma red (si usas celular).
* La base de datos ya está incluida en el proyecto.

---

## 👨‍💻 Autor

* Desarrollado por **AngelGDLSP**

---

## ⭐ Contribuciones

¡Las contribuciones son bienvenidas!
Puedes hacer un fork del proyecto y enviar un pull request.

---

## 📄 Licencia

Este proyecto es de uso educativo.
