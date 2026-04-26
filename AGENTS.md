# AGENTS.md - Movil Home Pay

## Project
- **Type**: Flutter mobile app (iOS/Android)
- **Stack**: Flutter 3.41.7+, Dart 3.11.5+, BLoC pattern

## Commands

```bash
flutter run           # Run app
flutter analyze       # Lint + typecheck (same as flutter pub run analyze)
flutter test         # Run tests
flutter pub get       # Install dependencies
```

## Architecture

Clean Architecture with `features/` directory:
```
lib/
├── core/              # Shared: config, DI, theme, auth
├── features/
│   ├── auth/         # Login, auth bloc
│   └── cuentas/      # Accounts: pages, bloc, repository, entities
└── main.dart         # Entry point + router config
```

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

Major packages: flutter_bloc, go_router, dio, get_it, clerk_flutter, clerk_auth, flutter_dotenv
