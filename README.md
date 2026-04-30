# Movil Home Pay

A Flutter-based mobile application project.

## Getting Started

### Prerequisites
- **Flutter SDK**: 3.41.7 or higher
- **Channel**: Stable

### Configuration
This project requires environment variables for authentication and API communication. 

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
2. Update the following variables in `.env`:
   - `API_BASE_URL`: Base URL for the backend services.
   - `CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key.
   - `CLERK_SECRET_KEY`: Your Clerk secret key.

### Installation
1. Fetch dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## CI/CD and Automation
The project uses GitHub Actions for continuous validation and quality control:

- **Control de Versiones**: Ensures versioning consistency in `pubspec.yaml`.
- **📚 Continuous Documentation**: Automatically analyzes pull requests to detect documentation drift and suggest updates.
- **Build & Test**: Performs static analysis using `flutter analyze` and executes unit tests with coverage reporting.

## Project Structure
- `lib/`: Main source code.
- `.github/workflows/`: CI/CD pipeline definitions.
- `.env.example`: Template for required environment variables.