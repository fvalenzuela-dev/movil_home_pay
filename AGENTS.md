# Agent Context & Project Standards

This document provides context for AI agents working on the HomePay Mobile repository.

## Project Nature
- **Type**: Flutter Mobile Application
- **Architecture**: Feature-driven (Auth, Cuentas, Categorias)
- **State Management**: Bloc (as indicated by file structure)

## Tech Stack Standards
- **Flutter Version**: `3.41.7`
- **Authentication**: Clerk (via `clerk_datasource.dart` and `AuthBloc`)
- **API Communication**: Configured via `API_BASE_URL` in `.env` files.
- **Versioning Source**: `pubspec.yaml` (Used by CI/CD workflows).

## Workflow Instructions
- **Linting**: Always ensure code passes `flutter analyze`.
- **Testing**: New features must include tests executable via `flutter test`.
- **Environment**: Secrets and API keys must never be hardcoded; use the `TokenProvider` and environment variables.

## Development Guidelines
- The project has migrated from a Go-based backend focus to a Flutter mobile frontend.
- Deployment workflows for Docker/GCP have been deprecated in favor of mobile-specific validation pipelines.