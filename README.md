# Movil Home Pay

App para administrar pagos de cuentas del hogar.

## Requisitos

- Flutter 3.41.7+
- Dart 3.11.5+

## Configuración

1. Instalar dependencias:
   ```bash
   flutter pub get
   ```

2. Configurar variables de entorno en `.env`:
   ```
   API_BASE_URL=http://localhost:8082
   CLERK_PUBLISHABLE_KEY=pk_test_...
   ```

## Comandos

### Desarrollo
```bash
flutter run              # Ejecutar app
flutter run -d <device> # Ejecutar en dispositivo específico
flutter analyze         # Lint + typecheck
flutter test            # Ejecutar tests
```

### Build
```bash
# Android APK debug
flutter build apk --debug

# Android APK release
flutter build apk --release

# iOS (solo macOS)
flutter build ios --release
flutter build ios --simulator --no-codesign
```

### Publicación

```bash
# Android Play Store
flutter build appbundle --release

# iOS App Store
flutter build ipa --release
```

### Limpieza
```bash
flutter clean
flutter pub get
```
