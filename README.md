# Home Pay Mobile

Initial project setup for the Home Pay mobile application using Flutter.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.41.7` stable)
- [Clerk Account](https://clerk.com/) for authentication services

## Environment Setup

The project requires several environment variables to function correctly. Copy the example file and fill in your credentials:

```bash
cp .env.example .env
```

Required variables:
- `API_BASE_URL`: The base URL for the backend API services (default: `http://localhost:8082`).
- `CLERK_PUBLISHABLE_KEY`: Your publishable key from the Clerk dashboard.

## Getting Started

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Analyze the code:**
   ```bash
   flutter analyze
   ```

3. **Run tests:**
   ```bash
   flutter test
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## Project Features

- **Authentication**: Integrated with Clerk for secure user management.
- **Cuentas**: Management of user accounts.
- **Categorias**: Categorization for transactions/data.

## CI/CD Pipeline

The project uses GitHub Actions for continuous validation:
- **Version Control**: Monitored via `pubspec.yaml`.
- **Validation**: Automatically runs Flutter analysis and tests on pull requests.
- **Code Coverage**: Generated during the test phase and stored as artifacts.