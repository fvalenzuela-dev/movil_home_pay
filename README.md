# Movil Home Pay

Initial project setup for account and category management.

## Technology Stack
- **Framework:** Flutter
- **Authentication:** Clerk
- **CI/CD:** GitHub Actions

## Getting Started

### Prerequisites
- Flutter SDK (v3.41.7 or higher)
- Dart SDK

### Environment Configuration
Before running the application, you must set up your environment variables:

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Configure the following variables in `.env`:
   - `API_BASE_URL`: The base URL for the API services (default: `http://localhost:8082`).
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key from the Clerk dashboard.

### Installation
To install dependencies, run:
```bash
flutter pub get
```

### Running the Application
To run the app in debug mode:
```bash
flutter run
```

## CI/CD and Quality Control
The project uses GitHub Actions for continuous validation:
- **Version Check:** Automatically validates the versioning defined in `pubspec.yaml`.
- **Linting:** Runs `flutter analyze` to ensure code quality and style consistency.
- **Tests:** Runs `flutter test` and generates coverage reports (lcov format).

## Project Structure
- `lib/core/auth`: Core authentication logic and token providers.
- `lib/features/auth`: Clerk-based authentication implementation (data sources, repositories, and UI).
- `lib/features/`: Contains domain-driven modules for accounts (cuentas) and categories (categorias).