import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/core/auth/token_provider.dart';

void main() {
  setUp(() {
    // Clear token before each test
    TokenProvider.clearToken();
  });

  group('TokenProvider', () {
    group('setGetter', () {
      test('stores the getter function', () async {
        bool getterCalled = false;
        TokenProvider.setGetter(() async {
          getterCalled = true;
          return 'test-token';
        });

        await TokenProvider.getToken();

        expect(getterCalled, true);
      });
    });

    group('getToken', () {
      test('returns token from getter when configured', () async {
        TokenProvider.setGetter(() async => 'my-test-token');

        final token = await TokenProvider.getToken();

        expect(token, 'my-test-token');
      });

      test('returns null when getter is not configured', () async {
        final token = await TokenProvider.getToken();

        expect(token, isNull);
      });

      test('returns null when getter throws exception', () async {
        TokenProvider.setGetter(() async {
          throw Exception('Network error');
        });

        final token = await TokenProvider.getToken();

        expect(token, isNull);
      });

      test('calls getter each time (not cached)', () async {
        int callCount = 0;
        TokenProvider.setGetter(() async {
          callCount++;
          return 'token-$callCount';
        });

        final token1 = await TokenProvider.getToken();
        final token2 = await TokenProvider.getToken();
        final token3 = await TokenProvider.getToken();

        expect(callCount, 3);
        expect(token1, 'token-1');
        expect(token2, 'token-2');
        expect(token3, 'token-3');
      });

      test('returns null when getter returns null', () async {
        TokenProvider.setGetter(() async => null);

        final token = await TokenProvider.getToken();

        expect(token, isNull);
      });

      test('returns null when getter returns empty string', () async {
        TokenProvider.setGetter(() async => '');

        final token = await TokenProvider.getToken();

        expect(token, isEmpty);
      });
    });

    group('clearToken', () {
      test('removes the getter', () async {
        TokenProvider.setGetter(() async => 'test-token');
        TokenProvider.clearToken();

        final token = await TokenProvider.getToken();

        expect(token, isNull);
      });

      test('can set a new getter after clearing', () async {
        TokenProvider.setGetter(() async => 'first-token');
        TokenProvider.clearToken();
        TokenProvider.setGetter(() async => 'second-token');

        final token = await TokenProvider.getToken();

        expect(token, 'second-token');
      });
    });
  });
}
