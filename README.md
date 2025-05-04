# App de Ejercicio Híbrido

Aplicación móvil para rutinas de ejercicio personalizadas que puedes realizar en casa, gimnasio o con entrenamientos híbridos (para correr, saltar, nadar, artes marciales, etc).

## 🔥 Características principales

- Registro e inicio de sesión con Firebase.
- Rutinas por nivel: principiante, intermedio, avanzado.
- Entrenamientos híbridos: potencia, agilidad, resistencia.
- Historial de rutinas realizadas.
- Acceso offline a rutinas guardadas.

## 👨‍💻 Equipo de Desarrollo

- Ricardo (Firebase, backend, lógica general)
- Yael (interfaces móviles y pantallas)
- Johan (UX y lógica de selección)
- Ramses (estructura de datos e historial)
- Leo (QA, pruebas, soporte de integración)

## 🛠 Tecnologías

- Flutter
- Firebase Auth & Firestore
- Dart

---

### 🚀 Instrucciones

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/dinovillalobos/app_gym.git
   cd app_gym
   flutter pub get

### 📁 Estructura recomendada
   lib/
   ├── main.dart
   ├── core/                   # Funciones comunes (helpers, constantes, estilos, etc.)
   │   ├── constants.dart
   │   ├── firebase_service.dart  # Funciones generales de Firestore
   │   └── utils.dart
   ├── models/                # Modelos de datos
   │   ├── rutina_model.dart
   │   ├── ejercicio_model.dart
   │   ├── usuario_model.dart
   │   └── progreso_model.dart
   ├── services/              # Abstracción de Firebase por módulo
   │   ├── rutina_service.dart
   │   ├── ejercicio_service.dart
   │   └── auth_service.dart
   ├── screens/               # Pantallas principales
   │   ├── home_screen.dart
   │   ├── login_screen.dart
   │   ├── rutina_detail_screen.dart
   │   ├── crear_rutina_screen.dart
   │   └── registro_screen.dart
   ├── widgets/               # Widgets reutilizables
   │   ├── rutina_card.dart
   │   ├── ejercicio_tile.dart
   │   └── loading_indicator.dart
   └── providers/             # State Management (opcional)
   ├── auth_provider.dart
   └── rutina_provider.dart


