# Home Pay Mobile

Flutter mobile application for the Home Pay ecosystem.

## 🛠 Tech Stack

- **Framework:** Flutter (Channel: stable, Version: 3.41.7)
- **Authentication:** Clerk
- **State Management:** BLoC / Cubit
- **CI/CD:** GitHub Actions

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.41.7)
- Dart SDK
- A mobile emulator or physical device (Android/iOS)

### Environment Configuration

The project requires environment variables to function. 

1. Copy the example file:
   ```bash
   cp .env.example .env
   ```
2. Update `.env` with your specific configuration:
   - `API_BASE_URL`: Base URL for the backend services.
   - `CLERK_PUBLISHABLE_KEY`: Clerk authentication publishable key.
   - `CLERK_SECRET_KEY`: Clerk secret key.

### Installation

1. Fetch the project dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application in debug mode:
   ```bash
   flutter run
   ```

## 🧪 Quality Control

### Analysis & Linting

To check for potential issues and style violations:
```bash
flutter analyze
```

### Testing

To run unit and widget tests with coverage reporting:
```bash
flutter test --coverage
```

## 🔄 CI/CD Pipelines

- **Central Validation**: Triggered on pull requests. Performs version checks via `pubspec.yaml`, runs `flutter analyze`, and executes tests to ensure code quality.
- **Continuous Documentation**: Automatically detects and suggests updates to documentation based on code changes.

## 📦 Versioning

This project follows semantic versioning managed within the `pubspec.yaml` file.