# Movil Home Pay

A Flutter-based mobile application project. This project was recently initialized and migrated from a Go-based environment to a Flutter framework.

## Prerequisites

- **Flutter SDK**: version 3.41.7 (stable)
- **Dart SDK**
- **Clerk Account**: For authentication services

## Getting Started

### 1. Environment Configuration

Copy the `.env.example` file to a new file named `.env` and fill in the required credentials:

```bash
cp .env.example .env
```

Required variables:
- `API_BASE_URL`: The base URL for your API services.
- `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key from the Clerk dashboard.
- `CLERK_SECRET_KEY`: Your Clerk secret key.

### 2. Install Dependencies

Fetch the required Flutter packages:

```bash
flutter pub get
```

### 3. Running the Project

To run the application in development mode:

```bash
flutter run
```

## Project Structure

- `lib/`: Main application source code.
- `test/`: Unit and widget tests.
- `.github/workflows/`: CI/CD pipelines including central validation (Flutter analyze and test).

## CI/CD and Quality Control

The project uses GitHub Actions to automate validation. The pipeline performs:
- Version consistency checks via `pubspec.yaml`.
- Code analysis using `flutter analyze`.
- Testing with coverage reports using `flutter test --coverage`.

## Authentication

Authentication is managed via **Clerk**. Ensure you have the appropriate keys configured in your `.env` file for the auth providers to function correctly.