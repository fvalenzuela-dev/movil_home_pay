# Movil Home Pay

Movil Home Pay is a mobile application built with Flutter designed for personal finance management, allowing users to manage accounts (cuentas) and categories (categorias).

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Channel: stable, Version: 3.41.7)
- **Language:** Dart
- **Authentication:** [Clerk](https://clerk.com/)
- **State Management:** BLoC (AuthBloc)

## Project Setup

### Prerequisites

- Flutter SDK installed and configured.
- A Clerk account and project configured.

### Environment Configuration

The project requires several environment variables to function. Create a `.env` file in the root directory based on `.env.example`:

```bash
# API Configuration
API_BASE_URL=your_api_endpoint

# Clerk Authentication
CLERK_PUBLISHABLE_KEY=your_publishable_key
CLERK_SECRET_KEY=your_secret_key
```

### Installation

1. Fetch dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application:
   ```bash
   flutter run
   ```

## CI/CD and Quality Assurance

This project uses GitHub Actions for automated validation via the `central-validation.yml` workflow:

- **Version Check:** Monitors version consistency in `pubspec.yaml`.
- **Static Analysis:** Runs `flutter analyze` to ensure code quality and adherence to linting rules.
- **Tests:** Executes `flutter test` with coverage reporting.
- **Documentation:** Continuous documentation workflow monitors PRs for documentation drift.

## Features

- **Authentication:** Secure login using Clerk integration.
- **Accounts:** Manage different financial accounts.
- **Categories:** Organize transactions using customizable categories.