# AI Agent Guidelines - Movil Home Pay

This project has transitioned from a Go-based backend to a **Flutter** mobile application architecture. Agents should adhere to the following technical context:

## Technical Context
- **Primary Language**: Dart
- **Framework**: Flutter
- **Authentication**: Clerk (managed via `ClerkDataSource` and `TokenProvider`)
- **State Management**: BLoC pattern
- **Architecture**: Clean Architecture

## Development Workflow
- **Environment**: Use `.env.example` to set up the local development environment.
- **Versioning**: The source of truth for the project version is `pubspec.yaml`.
- **Testing**: All features must include tests executable via `flutter test`.
- **CI/CD**: PRs are validated through `flutter analyze` and `flutter test --coverage`.

## Key Directories
- `lib/features/`: Contains feature-specific logic (Auth, Cuentas, Categorias).
- `lib/core/`: Shared utilities, themes, and authentication providers.
- `.github/workflows/`: Contains the Flutter validation and documentation pipelines.