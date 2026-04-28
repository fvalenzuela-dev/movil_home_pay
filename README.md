# Movil Home Pay

Initial project setup for managing accounts (cuentas) and categories (categorias) with integrated authentication.

## 🚀 Getting Started

This project is built using **Flutter** and uses **Clerk** for authentication management.

### Prerequisites

- Flutter SDK (v3.41.7 stable recommended)
- Dart SDK
- A Clerk account for authentication keys

### ⚙️ Configuration

The application requires environment variables to function correctly. 

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Open `.env` and fill in your specific configuration:
   - `API_BASE_URL`: The base endpoint for the backend API.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk Publishable Key.
   - `CLERK_SECRET_KEY`: Your Clerk Secret Key.

### 🛠️ Installation & Development

Install dependencies:
```bash
flutter pub get
```

Run the application:
```bash
flutter run
```

### 🧪 Testing and Quality

Run static analysis:
```bash
flutter analyze
```

Run tests with coverage:
```bash
flutter test --coverage
```

## 🤖 CI/CD

The project uses GitHub Actions for continuous integration:
- **Control de Versiones**: Tracks versioning through `pubspec.yaml`.
- **CI Pipeline**: Automatically runs analysis and tests on pull requests.
- **Continuous Documentation**: Keeps documentation in sync with code changes.

## 📁 Project Structure

- `lib/features/auth`: Clerk authentication implementation (BLoC pattern).
- `lib/features/accounts`: Management logic for financial accounts.
- `lib/features/categorias`: Management logic for transaction categories.