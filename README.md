# Movil Home Pay

Flutter mobile application for payment management.

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `3.41.7` (Stable channel)
- **Dart SDK**
- **Clerk Authentication**: An account and project configured on the [Clerk Dashboard](https://clerk.com/).

### Configuration
This project requires environment variables to function correctly. 

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Update the values in `.env` with your credentials:
   - `API_BASE_URL`: The base endpoint for project APIs.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key.
   - `CLERK_SECRET_KEY`: Your Clerk secret key.

### Installation
Fetch the project dependencies using the Flutter CLI:
```bash
flutter pub get
```

### Running the App
To run the application in your connected device or emulator:
```bash
flutter run
```

## 🧪 Quality Control & Testing

The project uses GitHub Actions for continuous validation (see `.github/workflows/central-validation.yml`).

- **Static Analysis**: Run `flutter analyze` to check for linting issues.
- **Unit Testing**: Run `flutter test --coverage` to execute tests and generate coverage reports.
- **Version Control**: Project versioning is managed via `pubspec.yaml`.

## 🏗 Architecture
The project follows a modular structure:
- `lib/core`: Shared logic and authentication providers.
- `lib/features`: Feature-based modules (Auth, etc.) following the Data/Domain/Presentation pattern.
- `lib/features/auth`: Integration with Clerk for user authentication.

## 🛠 CI/CD
Validation is automated through GitHub Actions. Note that legacy GCP deployment workflows have been removed in favor of Flutter-specific validation pipelines.