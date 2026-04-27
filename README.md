# Movil Home Pay

Este es un proyecto de Flutter para la gestión de finanzas personales, incluyendo autenticación, cuentas y categorías.

## Requisitos Previos

- Flutter SDK (Versión 3.41.7 o superior)
- Dart SDK
- Cuenta en Clerk para la autenticación

## Configuración

1. **Variables de Entorno:**
   Copia el archivo `.env.example` a `.env` y completa los valores requeridos:
   ```bash
   cp .env.example .env
   ```
   - `API_BASE_URL`: URL base de la API (por defecto http://localhost:8082).
   - `CLERK_PUBLISHABLE_KEY`: Tu llave pública obtenida desde el dashboard de Clerk.

2. **Instalación de Dependencias:**
   Ejecuta el siguiente comando para obtener los paquetes de Flutter:
   ```bash
   flutter pub get
   ```

## Ejecución

Para iniciar la aplicación en modo desarrollo:
```bash
flutter run
```

## Integración Continua (CI)

El proyecto cuenta con flujos de trabajo en GitHub Actions para:
- **Control de Versiones:** Validado automáticamente a través del archivo `pubspec.yaml` (anteriormente `VERSION`).
- **Validación Central:** Ejecuta `flutter analyze` y `flutter test` con generación de reportes de cobertura en `coverage/lcov.info`.
- **Documentación Continua:** Mantiene la documentación técnica sincronizada con los cambios en el código.

## Estructura del Proyecto

El proyecto sigue una arquitectura limpia (Clean Architecture):
- `lib/features/auth`: Implementación de autenticación utilizando Clerk.
- `lib/features/cuentas`: Módulo para la gestión de cuentas financieras.
- `lib/features/categorias`: Módulo para la clasificación de transacciones.
- `lib/core`: Utilidades compartidas, interceptores y proveedores de tokens de autenticación.