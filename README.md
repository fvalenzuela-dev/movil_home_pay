# Movil Home Pay

Initial project setup for a Flutter-based mobile application focused on financial management.

## Overview

This project provides a platform for managing accounts and categories, utilizing Clerk for secure authentication and a Clean Architecture approach for maintainability.

## Prerequisites

- **Flutter SDK**: `3.41.7` (Stable channel)
- **Dart SDK**: Integrated with Flutter

## Environment Variables

Configure your environment by creating a `.env` file based on `.env.example`:

```env
API_BASE_URL=http://localhost:8082
CLERK_PUBLISHABLE_KEY=pk_test_your_key_here
```

## Getting Started

1. **Clone the repository**
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the application**:
   ```bash
   flutter run
   ```

## Continuous Integration

The project uses GitHub Actions (defined in `.github/workflows/central-validation.yml`) for automated quality control:
- **Analysis**: Runs `flutter analyze` on every pull request to ensure code quality.
- **Tests**: Executes `flutter test` with coverage reports stored in the `coverage/` directory.
- **Version Management**: Project versioning is now managed via `pubspec.yaml` (replacing the previous `VERSION` file system).

## Architecture

The codebase follows Clean Architecture principles:
- **Features**: Scoped business logic (e.g., auth, cuentas, categorias).
- **Layers**: Separation of concerns into `data`, `domain`, and `presentation` layers.
- **State Management**: Implemented using the **BLoC** pattern.