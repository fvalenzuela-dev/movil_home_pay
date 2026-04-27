# Movil Home Pay

Initial project setup for Movil Home Pay, built with Flutter.

## Features

- **Authentication**: Integrated with Clerk Auth.
- **Modules**: Initial structure for Accounts (Cuentas) and Categories (Categorias).
- **Architecture**: Clean Architecture with BLoC for state management.

## Prerequisites

- **Flutter SDK**: `3.41.7` (Stable channel)
- **Dart SDK**: Compatible with the specified Flutter version.

## Getting Started

1. **Environment Configuration**:
   Copy the template and provide your specific keys:
   ```bash
   cp .env.example .env
   ```
   Key variables:
   - `API_BASE_URL`: Backend service endpoint.
   - `CLERK_PUBLISHABLE_KEY`: Clerk authentication key.

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Application**:
   ```bash
   flutter run
   ```

## CI/CD and Automation

This project uses GitHub Actions for quality control:
- **Version Control**: Validates versioning based on `pubspec.yaml`.
- **Quality Guard**: Runs `flutter analyze` and `flutter test` with coverage reporting on every PR.
- **Documentation**: Automatic drift detection for README and code documentation.

## Project Structure

- `lib/core`: Shared utilities and authentication providers.
- `lib/features`: Domain-driven modules (Auth, Accounts, Categories).
- `test`: Unit and widget tests.
