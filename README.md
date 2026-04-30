# Movil Home Pay

Flutter mobile application for home payment management, featuring Clerk authentication and automated CI/CD integration.

## Prerequisites

- **Flutter SDK**: `3.41.7`
- **Channel**: `stable`
- **Dart SDK**: Compatible with the specified Flutter version.

## Getting Started

### 1. Environment Configuration

The project requires several environment variables to handle authentication and API communication. Create a `.env` file in the root directory based on the example provided:

```bash
cp .env.example .env
```

Fill in the following values:
- `API_BASE_URL`: Base URL for the backend API services.
- `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key for user authentication.
- `CLERK_SECRET_KEY`: Your Clerk secret key.

### 2. Installation

Install the project dependencies using the Flutter CLI:

```bash
flutter pub get
```

### 3. Running the App

To launch the application on a connected device or emulator:

```bash
flutter run
```

## CI/CD Workflows

This project implements a robust validation pipeline via GitHub Actions:

- **Version Control**: Automatically checks that the version in `pubspec.yaml` is updated correctly during PRs to `main` or `develop` branches.
- **Static Analysis**: Runs `flutter analyze` to ensure code quality and adherence to linting rules.
- **Testing & Coverage**: Executes `flutter test --coverage` and uploads reports to maintain high testing standards.
- **Documentation**: Includes a `Continuous Documentation` workflow to keep technical docs in sync with code changes.

## Project Architecture

The project follows a feature-based structure:
- `lib/core/auth`: Authentication providers and token management.
- `lib/features/auth`: Clerk-based authentication implementation (Data sources, Repositories, BLoC, and Pages).

## Ignored Files

Standard Flutter/Dart build artifacts, `.env` files, and IDE-specific configurations are excluded from version control via `.gitignore`.