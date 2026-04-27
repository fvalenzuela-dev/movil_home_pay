# Movil Home Pay

Flutter application for managing accounts and categories.

## Prerequisites

- Flutter SDK: `3.41.7`
- Dart SDK

## Project Setup

1. **Environment Variables**
   Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
   Update the following variables in `.env`:
   - `API_BASE_URL`: The base URL of the backend API (default: http://localhost:8082).
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key for authentication.

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Features

- **Authentication**: Integrated with Clerk Auth.
- **Accounts (Cuentas)**: Manage and track different financial accounts.
- **Categories (Categorias)**: Organize and classify your records.

## CI/CD and Quality

This project uses GitHub Actions for automated workflows:
- **Control de Versiones**: Tracks versions via `pubspec.yaml` (main branch).
- **Validation**: Runs `flutter analyze` and `flutter test --coverage` on every PR.
- **Continuous Documentation**: Automatically detects drift between code and documentation.

## Development

The project structure follows Flutter's standard architecture. Metadata for the project can be found in `.metadata` and project context in `.ship-safe/context.json`.