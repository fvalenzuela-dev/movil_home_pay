# Movil Home Pay

Initial project setup for managing accounts and categories, built with Flutter.

## Features

- **Authentication**: Integrated with Clerk for secure user management..
- **Core Entities**: Foundation for managing Accounts (Cuentas) and Categories (Categorías).
- **Architecture**: Clean Architecture structure with BLoC for state management.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel, version 3.41.7 recommended)
- Dart SDK

## Environment Configuration

The project uses environment variables for API and Authentication configuration. Create a `.env` file in the root directory based on the example provided:

```bash
cp .env.example .env
```

Required variables:
- `API_BASE_URL`: Base endpoint for the backend services.
- `CLERK_PUBLISHABLE_KEY`: Publishable key from your Clerk dashboard.
- `CLERK_SECRET_KEY`: Secret key from your Clerk dashboard.

## Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Static Analysis**:
   ```bash
   flutter analyze
   ```

3. **Run Tests**:
   ```bash
   flutter test --coverage
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration:
- **Control de Versiones**: Monitors versioning specifically in `pubspec.yaml`.
- **Validation**: Automatically runs Flutter analyze and tests on every pull request to ensure code quality and coverage.
