# Movil Home Pay

App móvil para administrar pagos de cuentas del hogar. Administra tus cuentas, gastos y categorías de manera sencilla.

## Requisitos

- Flutter 3.41.7+
- Dart 3.11.5+
- Xcode 15+ (para iOS)
- Android SDK (para Android)

## Estructura del Proyecto

El proyecto sigue **Clean Architecture** con el patrón **BLoC** para gestión de estado:

```
lib/
├── core/                      # Configuración compartida
│   ├── auth/                  # Autenticación (Clerk)
│   ├── config/                # Configuraciones (API, Clerk)
│   ├── di/                    # Inyección de dependencias (get_it)
│   └── theme/                 # Tema de la app
├── features/                  # Features del dominio
│   ├── auth/                  # Autenticación y login
│   │   ├── data/
│   │   │   ├── datasources/   # Fuentes de datos
│   │   │   └── repositories/  # Implementación de repositorios
│   │   ├── domain/
│   │   │   ├── entities/      # Entidades del dominio
│   │   │   └── repositories/ # Interfaces de repositorios
│   │   └── presentation/
│   │       ├── bloc/          # BLoC de autenticación
│   │       └── pages/         # Páginas de auth
│   ├── cuentas/               # Gestión de cuentas
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── admin/                 # Panel de administración
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart                  # Entry point + router
```

## Tech Stack

- **Framework**: Flutter 3.41.7+
- **Language**: Dart 3.11.5+
- **State Management**: flutter_bloc (BLoC pattern)
- **Dependency Injection**: get_it
- **Routing**: go_router
- **HTTP Client**: dio
- **Authentication**: Clerk (clerk_flutter, clerk_auth)
- **Environment**: flutter_dotenv

## Configuración

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Variables de entorno

Crear archivo `.env` en la raíz del proyecto:

```env
API_BASE_URL=http://localhost:8082
CLERK_PUBLISHABLE_KEY=pk_test_...
```

### 3. Configuración de Clerk

La app usa [Clerk](https://clerk.com) para autenticación. Configurar en `lib/core/config/clerk_config.dart`:

```dart
const String clerkPublishableKey = String.fromEnvironment(
  'CLERK_PUBLISHABLE_KEY',
  defaultValue: 'pk_test_...',
);
```

## Comandos

### Desarrollo

```bash
# Ejecutar app
flutter run

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Lint + typecheck (equivalente a flutter pub run analyze)
flutter analyze

# Ejecutar tests
flutter test

# Obtener dependencias
flutter pub get
```

### Build

```bash
# Android APK debug
flutter build apk --debug

# Android APK release
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (solo macOS)
flutter build ios --release

# iOS Simulator
flutter build ios --simulator --no-codesign

# iOS IPA (App Store)
flutter build ipa --release
```

### Limpieza

```bash
flutter clean
flutter pub get
```

## Features

### Autenticación (Auth)
- Login con Clerk
- Gestión de sesión de usuario
- Token provider para API

### Cuentas
- Lista de cuentas por período
- Detalle de cuenta
- Estados de cuenta (pendiente, pagada, etc.)
- Widgets reutilizables (CuentaCard, EstadoBadge)

### Administración
- Gestión de categorías
- Panel de administración

## Testing

Framework: flutter_test + bloc_test + mocktail

Ejecutar tests:
```bash
flutter test
```

Archivo de test: `test/widget_test.dart`

## Contribución

1. Crear rama desde `main` o `develop`
2. Hacer cambios en rama feature/fix/etc
3. Crear PR con descripción
4. Esperar review

## Licencia

Privado - Todos los derechos reservados
