# movil_home_pay

A new Flutter project for Home Pay services.

## Description
This project has been initialized as a Flutter application, replacing the previous Go-based architecture. It includes integrated CI/CD workflows for Flutter analysis, testing, and coverage reporting.

## Prerequisites
- Flutter SDK (Channel stable, Version 3.41.7 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development

## Getting Started

### Environment Configuration
1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Update the following variables in `.env` with your credentials:
   - `API_BASE_URL`: The base URL for the backend services.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key for authentication.
   - `CLERK_SECRET_KEY`: Your Clerk secret key.

### Installation
```bash
flutter pub get
```

### Running the App
```bash
flutter run
```

## Development

### Testing
Run the test suite with coverage:
```bash
flutter test --coverage
```

### Static Analysis
Check for code quality and linting issues:
```bash
flutter analyze
```

## CI/CD
The project uses GitHub Actions for continuous validation:
- **Control de Versiones**: Monitors `pubspec.yaml` for version changes.
- **Pruebas y Calidad**: Automatically runs flutter analyze and tests on pull requests.
- **Continuous Documentation**: Ensures documentation stays in sync with code changes.