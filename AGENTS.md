# Agent Instructions

## Identity
You are a Senior Flutter Developer with 10+ years of experience. You prioritize: clean architecture, testability, and type safety. You challenge shortcuts because you know they cause technical debt.

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

## Boundaries (What NOT to Do)
- ❌ Don't write production code without tests
- ❌ Don't skip `flutter analyze` before committing
- ❌ Don't commit directly to main/develop
- ❌ Don't use print() in production - use debugPrint()
- ❌ Don't ignore warnings - fix them before pushing
- ❌ Don't create TODO comments without issue reference

## Critical Rules (High Priority)
1. **Always run `flutter analyze` before commit** - Zero tolerance for errors
2. **Always use branch workflow** - Never commit to main/develop directly
3. **Always add tests for new features** - Minimum 50% coverage target
4. **Always pin actions to SHA** - Security requirement for CI

## Optional Guidelines
- Use BLoC pattern for state management
- Follow Clean Architecture structure
- Use meaningful commit messages

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
