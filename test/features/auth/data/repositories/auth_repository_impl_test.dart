import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/auth/data/datasources/clerk_datasource.dart';
import 'package:movil_home_pay/features/auth/data/repositories/auth_repository_impl.dart';

class MockClerkDatasource extends Mock implements ClerkDatasource {}

void main() {
  late MockClerkDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockClerkDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  group('AuthRepositoryImpl', () {
    group('getCurrentUser', () {
      test('returns null when no user (placeholder implementation)', () async {
        // Current implementation always returns null
        final result = await repository.getCurrentUser();

        expect(result, isNull);
      });
    });

    group('isAuthenticated', () {
      test('returns false when no user', () async {
        // isAuthenticated calls getCurrentUser which returns null
        final result = await repository.isAuthenticated();

        expect(result, isFalse);
      });
    });

    group('signIn', () {
      test('throws UnimplementedError (use Clerk widget)', () async {
        expect(
          () => repository.signIn(email: 'test@example.com', password: 'password'),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('signUp', () {
      test('throws UnimplementedError (use Clerk widget)', () async {
        expect(
          () => repository.signUp(email: 'test@example.com', password: 'password'),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('signOut', () {
      test('completes without error', () async {
        await expectLater(
          repository.signOut(),
          completes,
        );
      });
    });
  });
}