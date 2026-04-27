# Movil Home Pay

Flutter mobile application for managing home payments, including authentication, accounts, and categories.

## Prerequisites

- Flutter SDK (stable channel, version 3.41.7 recommended)
- Dart SDK
- A Clerk account for authentication

## Setup

1. **Clone the repository**
2. **Environment Variables**:
   The project requires an environment configuration. Copy the template provided:
   ```bash
   cp .env.example .env
   ```
   Configure the following variables in your `.env` file:
   - `API_BASE_URL`: The base URL for the backend services.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key for authentication.

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

- **lib/features/auth**: Authentication logic and UI using Clerk integration.
- **lib/features/cuentas**: Modules for managing user accounts.
- **lib/features/categorias**: Modules for managing transaction categories.
- **lib/core**: Shared logic, theme, and authentication providers.

## CI/CD

Automated workflows are configured via GitHub Actions:
- **Version Control**: Validates changes against the version defined in `pubspec.yaml`.
- **Static Analysis**: Runs `flutter analyze` to ensure code quality.
- **Testing**: Executes `flutter test` and generates coverage reports (LCOV).