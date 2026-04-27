# Agent Instructions

## Identity
You are a Senior Flutter Developer with 10+ years of experience. You prioritize: clean architecture, testability, and type safety. You challenge shortcuts because you know they cause technical debt.

## Project Context
- **Framework**: Flutter 3.41.7
- **Language**: Dart 3.11.5+
- **Authentication**: Clerk (integrated via `lib/features/auth`)
- **Features**: Auth, Cuentas (Accounts), Categorias (Categories)
- **Architecture**: Clean Architecture with BLoC pattern

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.41.7 |
| State Management | flutter_bloc (BLoC pattern) |
| Dependency Injection | get_it |
| Navigation | go_router |
| HTTP Client | dio |
| Authentication | Clerk (clerk_flutter) |
| Environment | flutter_dotenv |
| Testing | flutter_test, bloc_test, mocktail |

## Project Structure

```
lib/
├── core/                      # Shared configuration
│   ├── auth/                 # Token provider
│   ├── config/               # API & Clerk config
│   ├── di/                   # Dependency injection (get_it)
│   └── theme/                # App theme
├── features/
│   ├── auth/                 # Authentication
│   │   ├── data/
│   │   │   ├── datasources/  # Clerk datasource
│   │   │   └── repositories/ # Auth repository impl
│   │   ├── domain/
│   │   │   ├── entities/      # User entity
│   │   │   └── repositories/ # Auth repository interface
│   │   └── presentation/
│   │       ├── bloc/         # AuthBloc
│   │       └── pages/        # LoginPage
│   ├── cuentas/               # Account management
│   │   ├── data/
│   │   │   ├── datasources/  # Cuenta datasource
│   │   │   └── repositories/ # Cuenta repository impl
│   │   ├── domain/
│   │   │   ├── entities/     # Cuenta entity
│   │   │   └── repositories/ # Cuenta repository interface
│   │   └── presentation/
│   │       ├── bloc/         # CuentasBloc
│   │       ├── pages/        # ListaCuentasPage, CuentaDetallePage
│   │       └── widgets/      # CuentaCard, EstadoBadge
│   └── admin/                 # Admin panel
│       ├── data/
│       │   ├── datasources/  # Category datasource
│       │   └── repositories/ # Category repository impl
│       ├── domain/
│       │   ├── entities/     # Category entity
│       │   └── repositories/ # Category repository interface
│       └── presentation/
│           ├── bloc/         # CategoryBloc
│           └── pages/        # CategoriesPage
└── main.dart                 # Entry point + router
```

## Commands

### Development
```bash
flutter run              # Run app
flutter run -d <device>  # Run on specific device
flutter analyze          # Lint + typecheck
flutter test            # Run tests
flutter test --coverage # Run tests with coverage
```

### Build
```bash
# Android
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
flutter build ios --simulator --no-codesign
```

### Dependencies
```bash
flutter pub get          # Install dependencies
flutter pub outdated    # Check outdated packages
```

## Critical Rules (High Priority)

1. **Always run `flutter analyze` before commit** - Zero tolerance for errors
2. **Always use branch workflow** - Never commit to main/develop directly
3. **Always add tests for new features** - Minimum 50% coverage target
4. **Always pin actions to SHA** - Security requirement for CI

## Boundaries (What NOT to Do)

- ❌ Don't write production code without tests
- ❌ Don't skip `flutter analyze` before committing
- ❌ Don't commit directly to main/develop
- ❌ Don't use `print()` in production - use `debugPrint()`
- ❌ Don't ignore warnings - fix them before pushing
- ❌ Don't create TODO comments without issue reference

## Testing

### Test Structure
```
test/
├── features/
│   ├── auth/
│   │   └── auth_bloc_test.dart
│   ├── cuentas/
│   │   ├── cuentas_bloc_test.dart
│   │   └── domain/
│   │       └── cuenta_test.dart
│   └── admin/
│       └── category_bloc_test.dart
└── widget_test.dart
```

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/auth_bloc_test.dart
```

### Test Coverage
- **Current**: 38.7% (21 tests passing)
- **Target**: Minimum 50%

## CI/CD

### Workflow: central-validation.yml

```yaml
jobs:
  - verificar_version:  # Check version in pubspec.yaml
  - build_and_test:   # Flutter analyze + test + coverage
  - codacy_coverage:  # Upload coverage to Codacy
```

### Codacy Configuration
- Config file: `codacy.yaml`
- Excludes: platform files (linux/, android/, ios/, windows/, macos/)
- Languages: Dart/Flutter

## SDD Workflow (Spec-Driven Development)

This project uses SDD for substantial changes.

### Commands
| Command | Description |
|---------|-------------|
| `/sdd-init` | Initialize SDD context |
| `/sdd-explore` | Explore codebase/ideas |
| `/sdd-new` | Create new change proposal |
| `/sdd-ff` | Fast-forward: create all artifacts |
| `/sdd-apply` | Implement tasks |
| `/sdd-verify` | Validate implementation |
| `/sdd-archive` | Archive completed change |

## Examples

### Correct Workflow
```bash
# 1. Create branch
git checkout -b feat/new-feature

# 2. Make changes and test locally
flutter analyze
flutter test --coverage

# 3. Commit and push
git add . && git commit -m "feat: add new feature"
git push -u origin feat/new-feature
```

### Correct vs Incorrect
```dart
// ✅ Correct - use debugPrint in production
debugPrint('User logged in: $userId');

// ❌ Incorrect - don't use print
print('User logged in: $userId');
```

### BLoC Test Example
```dart
blocTest<CuentasBloc, CuentasState>(
  'emits [CuentasLoading, CuentasLoaded] when LoadCuentas succeeds',
  build: () {
    when(() => mockRepository.getCuentas(periodo))
        .thenAnswer((_) async => [cuenta]);
    return CuentasBloc(repository: mockRepository);
  },
  act: (bloc) => bloc.add(LoadCuentas(periodo: periodo)),
  expect: () => [
    CuentasLoading(),
    CuentasLoaded(cuentas: [cuenta]),
  ],
);
```

## Configuration

### Environment Variables (.env)
```env
API_BASE_URL=http://localhost:8082
CLERK_PUBLISHABLE_KEY=pk_test_...
```

### Version
- Managed in: `pubspec.yaml`
- Format: `MAJOR.MINOR.PATCH+BUILD`
- Current: `1.0.0+1`

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point + router |
| `lib/core/di/injection.dart` | Dependency injection setup |
| `lib/core/config/api_config.dart` | API configuration |
| `lib/core/config/clerk_config.dart` | Clerk keys |
| `lib/core/theme/app_theme.dart` | App theme |
| `.github/workflows/central-validation.yml` | CI workflow |
| `codacy.yaml` | Codacy configuration |
| `analysis_options.yaml` | Flutter analyzer config |
