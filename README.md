# Movil Home Pay

Proyecto móvil desarrollado con Flutter para la gestión de finanzas personales, incluyendo autenticación, cuentas y categorías.

## Requisitos

*   **Flutter**: 3.41.7 (canal stable)
*   **Dart SDK**
*   **Clerk**: Cuenta configurada para autenticación

## Configuración

1.  **Variables de Entorno**: El proyecto requiere un archivo `.env` en la raíz. Puedes basarte en el archivo `.env.example` proporcionado:
    ```bash
    # API Configuration
    API_BASE_URL=xxxxx

    # Clerk Authentication
    CLERK_PUBLISHABLE_KEY=xxxxxxx
    CLERK_SECRET_KEY=xxxxxxx
    ```

2.  **Instalación de Dependencias**:
    ```bash
    flutter pub get
    ```

## Ejecución

Para iniciar la aplicación en modo desarrollo:
```bash
flutter run
```

## Integración Continua (CI)

El proyecto utiliza GitHub Actions para validación automática:
- **Control de Versiones**: Se valida contra el archivo `pubspec.yaml`.
- **Análisis Estático**: Ejecuta `flutter analyze`.
- **Tests**: Ejecuta `flutter test --coverage` para asegurar la calidad del código.

## Arquitectura y Funcionalidades

- **Autenticación**: Integrada con Clerk.
- **Módulos principales**: Gestión de Cuentas y Categorías.
- **Estructura**: Sigue patrones de Clean Architecture con BLoC para el manejo de estados (según se indica en la estructura de archivos en `lib/features`).