# Movil Home Pay

This project is a Flutter mobile application for financial management, allowing users to track accounts (cuentas) and organize transactions into categories (categorias).

## Features

- **Authentication**: Secure login and user session management powered by Clerk.
- **Account Management**: Track and manage different financial accounts.
- **Category Organization**: Categorize financial data for better insights.

## Getting Started

### Prerequisites

- **Flutter SDK**: `3.41.7` (Stable channel)
- **Dart SDK**
- **Clerk Account**: For authentication keys.

### Configuration

The app uses environment variables for configuration. Create a `.env` file in the root directory:

```bash
cp .env.example .env
```

Update the values in `.env`:
- `API_BASE_URL`: The base URL for the backend API (default: `http://localhost:8082`).
- `CLERK_PUBLISHABLE_KEY`: Your publishable key from the Clerk dashboard.

### Installation

```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

## Development

### Code Analysis

Run the following command to check for linting issues:

```bash
flutter analyze
```

### Testing

Run unit and widget tests with coverage reporting:

```bash
flutter test --coverage
```

## CI/CD

The project uses GitHub Actions for continuous integration. The validation workflow ensures code quality through linting and automated testing, with versioning now managed via `pubspec.yaml`.