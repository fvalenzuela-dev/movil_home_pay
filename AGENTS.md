# AGENTS.md - Movil Home Pay

## Project
- **Type**: Flutter mobile app (iOS/Android)
- **Stack**: Flutter 3.41.7+, Dart 3.11.5+, BLoC pattern, Clean Architecture
- **Storage**: Engram (persistent memory)

## Commands

```bash
flutter run             # Run app
flutter analyze        # Lint + typecheck
flutter test           # Run tests
flutter pub get        # Install dependencies
flutter build apk      # Build Android APK
flutter build ios      # Build iOS
```

## Architecture

Clean Architecture with `features/` directory:

```
lib/
├── core/                   # Shared: config, DI, theme, auth
│   ├── auth/              # Token provider
│   ├── config/            # API & Clerk config
│   ├── di/                # get_it injection
│   └── theme/             # App theme
├── features/
│   ├── auth/              # Login, auth bloc
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   ├── cuentas/          # Accounts: pages, bloc, repository, entities
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── admin/            # Admin panel
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart             # Entry point + router config
```

## Features

| Feature    | Description                    |
|------------|--------------------------------|
| auth       | Authentication with Clerk     |
| cuentas    | Account management            |
| admin      | Admin panel with categories   |

## Key Config

- `.env` required: `API_BASE_URL`, `CLERK_PUBLISHABLE_KEY`
- Auth: Clerk (clerk_flutter, clerk_auth)
- State: flutter_bloc with BLoC pattern
- DI: get_it in `lib/core/di/injection.dart`
- Router: go_router with period-based routes (`/cuentas/:periodo`)

## Testing

- Framework: flutter_test + bloc_test + mocktail
- Test file: `test/widget_test.dart`

## Dependencies

Major packages:
- flutter_bloc
- go_router
- dio
- get_it
- clerk_flutter
- clerk_auth
- flutter_dotenv

## SDD Workflow

This project uses **Spec-Driven Development (SDD)** for substantial changes.

### Commands

| Command       | Description                          |
|---------------|--------------------------------------|
| `/sdd-init`   | Initialize SDD context               |
| `/sdd-explore`| Explore codebase/ideas              |
| `/sdd-new`    | Create new change proposal           |
| `/sdd-ff`     | Fast-forward: create all artifacts   |
| `/sdd-apply`  | Implement tasks                     |
| `/sdd-verify` | Validate implementation              |
| `/sdd-archive`| Archive completed change            |

### Artifact Store

- **Mode**: Engram (persistent memory)
- **Backend**: Engram service

## Git Workflow

**IMPORTANT**: Never work directly on `main` or `develop`.

1. Create a branch first (use `github-workflow` skill)
2. Implement changes
3. Commit and push
4. Create PR as draft
