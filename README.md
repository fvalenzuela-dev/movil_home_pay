# Movil Home Pay

Movil Home Pay es una aplicación móvil desarrollada con Flutter para la gestión de finanzas personales, permitiendo a los usuarios administrar cuentas y categorías.

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Channel: stable, Version: 3.41.7)
- **Language:** Dart
- **Authentication:** [Clerk](https://clerk.com/)
- **State Management:** BLoC (flutter_bloc)

## Project Setup

### Prerequisites

- Flutter SDK instalado y configurado.
- Una cuenta de Clerk configurada.

### Environment Configuration

El proyecto requiere variables de entorno. Crea un archivo `.env` en la raíz basado en `.env.example`:

```bash
# API Configuration
API_BASE_URL=xxxxx

# Clerk Authentication
CLERK_PUBLISHABLE_KEY=xxxxxxxx
CLERK_SECRET_KEY=xxxxxxxx
```

### Installation

1. Instalar dependencias:
   ```bash
   flutter pub get
   ```

2. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## CI/CD and Quality Assurance

Este proyecto usa GitHub Actions para validación automática:

- **Version Check:** Monitorea consistencia de versión en `pubspec.yaml`.
- **Static Analysis:** Ejecuta `flutter analyze` para asegurar calidad de código.
- **Tests:** Ejecuta `flutter test` con coverage.

## Features

- **Autenticación:** Login seguro usando Clerk.
- **Cuentas (Dashboard):** Gestión de cuentas financieras.
- **Categorías:** Organización de transacciones con categorías personalizables.
- **Empresas:** Gestión de empresas asociadas a transacciones.
- **Estructura:** Clean Architecture con BLoC para manejo de estados.
