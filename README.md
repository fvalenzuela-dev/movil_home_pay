# HomePay Mobile

A Flutter-based mobile application for personal finance management, featuring secure authentication and management of accounts and categories.

## Features

- **Auth**: Secure authentication integration using Clerk.
- **Accounts (Cuentas)**: Manage and track various financial accounts.
- **Categories (Categorias)**: Organize transactions with custom categories.

## Tech Stack

- **Framework**: Flutter 3.41.7 (Stable)
- **Language**: Dart
- **Authentication**: Clerk
- **CI/CD**: GitHub Actions

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) v3.41.7
- Android Studio / Xcode for mobile emulation

## Configuration

The project uses environment variables for API and Auth configuration. 

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Update `.env` with your local configuration:
   - `API_BASE_URL`: The URL of the HomePay backend API.
   - `CLERK_PUBLISHABLE_KEY`: Your publishable key from the Clerk dashboard.

## Getting Started

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run static analysis**:
   ```bash
   flutter analyze
   ```

3. **Run tests**:
   ```bash
   flutter test --coverage
   ```

4. **Launch the application**:
   ```bash
   flutter run
   ```

## CI/CD

This project uses GitHub Actions for continuous integration:
- **Control de Versiones**: Monitors `pubspec.yaml` for version consistency.
- **Validation**: Automatically runs `flutter analyze` and `flutter test` on every pull request to the `main` branch.