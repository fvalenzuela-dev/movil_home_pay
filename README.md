# Movil Home Pay

This project is a Flutter application designed for mobile platforms, integrating Clerk for authentication and a custom backend API.

## Prerequisites
- Flutter SDK (Stable channel, recommended version: `3.41.7`)
- Dart SDK
- An active Clerk account for authentication services

## Environment Configuration

The application requires several environment variables to function correctly. Create a `.env` file in the root directory based on the `.env.example` file:

```bash
# API Configuration
API_BASE_URL=your_api_url_here

# Clerk Authentication
CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key
CLERK_SECRET_KEY=your_clerk_secret_key
```

## Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Analysis**:
   ```bash
   flutter analyze
   ```

3. **Run Tests**:
   ```bash
   flutter test --coverage
   ```

4. **Launch Application**:
   ```bash
   flutter run
   ```

## CI/CD Pipeline

The project uses GitHub Actions for automated validation. The `central-validation.yml` workflow performs the following checks on Pull Requests:
- **Version Control**: Validates that the version in `pubspec.yaml` is correctly updated.
- **Static Analysis**: Ensures code complies with Flutter linting rules.
- **Unit Testing**: Executes the test suite and generates coverage reports (saved as artifacts).

## Project Structure
- `lib/`: Main application source code.
- `.github/workflows/`: CI/CD configuration files.
- `test/`: Unit and widget tests.