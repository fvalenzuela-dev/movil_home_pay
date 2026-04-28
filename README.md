# movil_home_pay

Initial project setup for the Home Pay mobile application, built with Flutter. This application provides management for accounts (cuentas) and categories (categorias) with integrated authentication.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Authentication**: [Clerk](https://clerk.com/)
- **CI/CD**: GitHub Actions

## Prerequisites

- Flutter SDK (Version `3.41.7` or compatible stable version)
- Dart SDK
- A valid Clerk account and API keys

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd movil_home_pay
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Environment Setup**:
   Create a `.env` file in the root directory by copying the example file:
   ```bash
   cp .env.example .env
   ```
   Fill in your specific configuration:
   - `API_BASE_URL`: The backend service endpoint.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key.
   - `CLERK_SECRET_KEY`: Your Clerk secret key.

## Running the App

To run the application in debug mode:

```bash
flutter run
```

## Testing and Quality

### Static Analysis
Check for code quality and linting issues:
```bash
flutter analyze
```

### Running Tests
Execute the test suite:
```bash
flutter test
```

### Coverage
To generate a coverage report:
```bash
flutter test --coverage
```
The LCOV report will be generated at `coverage/lcov.info`.

## Project Structure

The project follows a feature-based structure:
- `lib/core`: Core utilities and authentication providers.
- `lib/features/auth`: Authentication logic and UI components.
- `lib/features/cuentas`: Account management features.
- `lib/features/categorias`: Category management features.

## CI/CD Pipelines

- **Control de Versiones**: Validates versioning against `pubspec.yaml`.
- **PR Quality**: Runs analysis and tests on every pull request to ensure stability.
- **Continuous Documentation**: Monitors for documentation drift.