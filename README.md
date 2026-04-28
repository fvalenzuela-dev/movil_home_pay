# Movil Home Pay

A Flutter-based mobile application for financial management, featuring account (cuentas) and category (categorias) management with integrated Clerk authentication..

## Tech Stack
- **Framework:** Flutter (Channel: stable, Version: 3.41.7)
- **Authentication:** Clerk
- **Architecture:** Feature-driven (Auth, Cuentas, Categorias)

## Getting Started

### Prerequisites
- Flutter SDK (Recommended version: 3.41.7)
- Clerk Account and API Keys

### Configuration
1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Configure the following variables in your `.env` file:
   - `API_BASE_URL`: Base URL for the backend API.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key.
   - `CLERK_SECRET_KEY`: Your Clerk secret key.

### Installation
1. Fetch the required dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## CI/CD and Quality Control
The project uses GitHub Actions for automated validation through the `central-validation.yml` workflow:
- **Version Check:** Ensures version consistency using `pubspec.yaml`.
- **Analysis:** Performs static code analysis using `flutter analyze`.
- **Testing:** Runs unit tests and generates coverage reports via `flutter test --coverage`.

## Features
- **Authentication:** Managed via Clerk (see `lib/features/auth`).
- **Accounts (Cuentas):** Logic for managing user financial accounts.
- **Categories (Categorias):** Classification system for transactions.
