# DreamBoard 🌸✨

Una aplicación móvil aesthetic desarrollada en Flutter para descubrir, leer y guardar DreamToons (webtoons/cómics), así como imágenes de inspiración al estilo Pinterest.

---

## 📱 Descripción

DreamBoard es una app para amantes del anime, manga y arte digital. Permite a los usuarios explorar DreamToons, guardar imágenes en tableros personalizados, seguir artistas y personalizar el color de la app.

---

## ✨ Funcionalidades

- 📚 **DreamToons** — Lee webtoons con visor de imágenes y texto estilo manga
- 🖼️ **Feed de imágenes** — Estilo Pinterest con categorías (Arte, Aesthetic, Personajes, etc.)
- 🗂️ **Tableros** — Guarda tus DreamToons e imágenes favoritas
- 👤 **Perfiles de artista** — Sigue artistas y ve sus publicaciones
- 🎨 **Temas de color** — Personaliza el color de la app (Morado, Rosa, Azul, Menta, Durazno, Lavanda)
- 🔐 **Registro e inicio de sesión** — Sistema de autenticación local con Hive
- 📖 **Publicar DreamToons** — Los artistas pueden subir sus propias obras y capítulos

---

## 🛠️ Tecnologías

- **Flutter** — Framework de desarrollo móvil
- **Dart** — Lenguaje de programación
- **Hive** — Base de datos local
- **Provider** — Gestión de estado
- **Google Fonts** — Tipografías (Pacifico, Poppins)
- **Image Picker** — Selección de imágenes desde galería

---

## 🚀 Instalación

### Requisitos
- Flutter SDK 3.0 o superior
- Android Studio o VS Code
- Dispositivo Android o emulador

### Pasos

1. Clona el repositorio:
```bash
git clone https://github.com/kalumbre/dreamboard.git
cd dreamboard
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Corre la app:
```bash
flutter run
```

---

## 📁 Estructura del proyecto

```
lib/
├── core/theme/          # Colores y temas
├── models/              # Modelos de datos (Hive)
├── providers/           # ThemeProvider
├── screens/             # Pantallas de la app
│   ├── auth/            # Login, Register, Splash
│   ├── feed/            # Feed principal
│   ├── dreamtoon/       # Lector y detalle de DreamToons
│   ├── boards/          # Tableros
│   ├── profile/         # Perfil de usuario
│   ├── pinterest/       # Imágenes estilo Pinterest
│   └── settings/        # Configuración de color
├── services/            # HiveService
└── widgets/             # Widgets reutilizables
assets/
├── covers/              # Portadas de DreamToons
├── images/              # Imágenes del feed
└── logo.png             # Logo de la app
```

---

## 👩‍💻 Desarrollado por

**Karime Jailyn Bernal Sanchez y Laura Edith  Duran Mendoza ** — Proyecto escolar DreamBoard
