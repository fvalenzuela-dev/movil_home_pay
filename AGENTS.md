# Agent Instructions

This project has been transitioned from a Go-based project to a Flutter mobile application. Agents should focus on Dart and Flutter development patterns.

## Project Context
- **Framework**: Flutter 3.41.7
- **Authentication**: Clerk (integrated via `lib/features/auth`)
- **Features**: Auth, Cuentas (Accounts), Categorias (Categories)

## Tech Stack & Commands
- **Dependency Management**: Use `flutter pub get` to install dependencies.
- **Testing**: Use `flutter test --coverage` for running tests and generating coverage reports.
- **Linting**: Use `flutter analyze` to ensure code quality.
- **Configuration**: Use `.env` file for API and Clerk keys.
- **Versioning**: Versioning is managed in `pubspec.yaml` (the old `VERSION` file is deprecated).

## Deployment & Workflows
- The Docker-based GCP deployment workflows have been removed.
- Continuous Integration now runs on the `central-validation.yml` workflow using standard Flutter action steps.