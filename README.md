# Home Pay Mobile

This project is a Flutter mobile application integrated with Clerk for authentication and a custom API backend.

## Requirements

- **Flutter SDK**: 3.41.7 (Stable channel)
- **Dart**: Included with Flutter

## Project Configuration

The project uses environment variables for configuration. Copy the example file and fill in your credentials:

```bash
cp .env.example .env
```

### Environment Variables

- `API_BASE_URL`: The base endpoint for the backend services.
- `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key (found in the Clerk Dashboard).
- `CLERK_SECRET_KEY`: Your Clerk secret key.

## Getting Started

1.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run the application**:
    ```bash
    flutter run
    ```

3.  **Run code analysis**:
    ```bash
    flutter analyze
    ```

4.  **Run tests with coverage**:
    ```bash
    flutter test --coverage
    ```

## CI/CD and Automation

This repository uses GitHub Actions for workflow automation:
- **Central Validation**: Automatically runs on PRs to perform version checks (via `pubspec.yaml`), code analysis, and test coverage reporting.
- **Continuous Documentation**: Monitors code changes to ensure documentation stays in sync with implementation.

## Architecture

The project follows a feature-driven architecture:
- `lib/core`: Shared logic, providers, and authentication configuration.
- `lib/features`: Modular features (e.g., `auth`) containing data, domain, and presentation layers.