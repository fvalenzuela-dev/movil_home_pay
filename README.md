# Movil Home Pay

A Flutter-based mobile application for managing home payments, featuring Clerk authentication and Clean Architecture.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel, version 3.41.7 or higher)
- [Dart SDK](https://dart.dev/get-started/sdk)

## Getting Started

### 1. Environment Setup

Copy the example environment file and configure it with your credentials:

```bash
cp .env.example .env
```

The following variables are required:
- `API_BASE_URL`: The base endpoint for the backend API.
- `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key (found in the Clerk Dashboard).
- `CLERK_SECRET_KEY`: Your Clerk secret key.

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the Project

```bash
flutter run
```

## CI/CD & Validation

The project uses GitHub Actions for continuous integration:
- **Control de Versiones**: Monitors version consistency in `pubspec.yaml`.
- **Central Validation**: Performs static analysis (`flutter analyze`) and runs unit tests with coverage reporting on every pull request.
- **Continuous Documentation**: Automatically identifies and addresses documentation drift.

## Project Architecture

This project follows a feature-driven Clean Architecture approach:
- `lib/core`: Shared logic, authentication providers, and utilities.
- `lib/features`: Independent modules (e.g., `auth`) containing data sources, repositories, domain entities, and BLoC-based presentation logic.