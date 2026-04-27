# Movil Home Pay

Flutter mobile application for managing home payments, accounts, and categories.

## Features

- **Authentication:** Secure login using Clerk.
- **Accounts (Cuentas):** Management and tracking of different payment accounts.
- **Categories (Categorias):** Organization of payments by type.

## Prerequisites

- **Flutter SDK:** 3.41.7 (Stable channel)
- **Environment Variables:** Access to Clerk dashboard for API keys.

## Getting Started

1. **Environment Configuration**
   Copy the example environment file and provide your local/production values:
   ```bash
   cp .env.example .env
   ```
   Key variables needed:
   - `API_BASE_URL`: The endpoint for the backend services.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk project publishable key.

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## CI/CD & Quality Control

This project uses GitHub Actions for automated validation:
- **Version Check:** Monitors versioning in `pubspec.yaml`.
- **Flutter Analyze:** Static analysis of Dart code.
- **Automated Testing:** Runs `flutter test` with coverage reports.
- **Continuous Documentation:** Automatically detects drift in documentation.

## Architecture

The project follows a modular feature-based architecture:
- `lib/core`: Shared logic, auth providers, and utilities.
- `lib/features/auth`: Login and user management implementation.
- `lib/features/cuentas`: Account-related business logic and UI.
- `lib/features/categorias`: Category management logic and UI.