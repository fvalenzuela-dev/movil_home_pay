# Movil Home Pay

A Flutter-based mobile application for managing personal finances, featuring authentication, account tracking, and category management.

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** Dart
- **Authentication:** [Clerk](https://clerk.com/)
- **CI/CD:** GitHub Actions

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Stable channel, version 3.41.7 or higher)
- Android Studio / VS Code with Flutter extension

### Configuration

1. **Environment Variables**:
   Create a `.env` file in the root directory based on `.env.example`:
   ```bash
   cp .env.example .env
   ```
   Update the following values:
   - `API_BASE_URL`: The URL of your backend service.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key from the dashboard.

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Project**:
   ```bash
   flutter run
   ```

## 🧪 Development & Quality

### CI/CD

This project uses GitHub Actions for automated validation:
- **Control de Versiones**: Ensures versioning matches `pubspec.yaml`.
- **Central Validation**: Runs `flutter analyze` for code quality and `flutter test` for unit/widget testing with coverage reporting.
- **Continuous Documentation**: Automatically detects and handles documentation drift.

## 📁 Project Structure

- `lib/features/auth`: Clerk authentication implementation (Bloc/DataSources).
- `lib/features/cuentas`: Account management logic.
- `lib/features/categorias`: Category management logic.
- `lib/core`: Core utilities and authentication token providers.