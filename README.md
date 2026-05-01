# Movil Home Pay

A mobile application project built with Flutter.

## Prerequisites

- Flutter SDK (v3.41.7 or compatible stable version)
- Dart SDK

## Setup and Installation

1.  **Environment Configuration**:
    Copy the `.env.example` file to a new file named `.env` and fill in the required configuration:
    ```bash
    cp .env.example .env
    ```
    Required variables:
    - `API_BASE_URL`: The base endpoint for the backend API.
    - `CLERK_PUBLISHABLE_KEY`: Clerk Authentication publishable key.
    - `CLERK_SECRET_KEY`: Clerk Authentication secret key.

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the Application**:
    ```bash
    flutter run
    ```

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and validation:

- **Version Control**: Validates versioning consistency based on the `pubspec.yaml` file.
- **Build & Test**: Automatically runs `flutter analyze` and `flutter test` with coverage reporting on every pull request to `main` or `develop`.
- **Continuous Documentation**: Automates documentation updates to prevent drift between code and descriptions.

## Quality Tools

- **Static Analysis**: Run `flutter analyze` to ensure code quality and adherence to linting rules.
- **Testing**: Run `flutter test --coverage` to execute the test suite and generate coverage reports (located in the `coverage/` directory).