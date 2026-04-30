# Movil Home Pay

This is a Flutter-based mobile application project for the Home Pay system.

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (v3.41.7)
- **Language:** [Dart](https://dart.dev/)
- **Authentication:** [Clerk](https://clerk.com/)
- **State Management:** BLoC (detected in `lib/features/auth/presentation/bloc/`)
- **Architecture:** Feature-driven Clean Architecture

## Getting Started

### Prerequisites

- Flutter SDK: `3.41.7` (Stable channel)
- Android Studio / VS Code with Flutter extensions
- Clerk Account for authentication keys

### Environment Configuration

Create a `.env` file in the root directory and configure the following variables (refer to `.env.example`):

```env
# API Configuration
API_BASE_URL=your_api_base_url

# Clerk Authentication
CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key
CLERK_SECRET_KEY=your_clerk_secret_key
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

## CI/CD Pipeline

The project uses GitHub Actions for automated validation:

- **Version Control:** Monitors versioning consistency in `pubspec.yaml`.
- **Continuous Documentation:** Automated documentation drift analysis.
- **Build & Test:** Runs `flutter analyze` and `flutter test` with coverage reporting.

## Project Structure

- `lib/core`: Shared utilities, themes, and authentication providers.
- `lib/features`: Domain-driven feature modules (e.g., `auth`).
- `.github/workflows`: CI/CD pipeline definitions.
