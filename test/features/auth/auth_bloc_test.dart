import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/auth/domain/entities/user.dart';
import 'package:movil_home_pay/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      final bloc = AuthBloc();
      expect(bloc.state, isA<AuthInitial>());
      bloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when AuthCheckRequested is added',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when AuthSignOutRequested is added',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(AuthSignOutRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    group('AuthState', () {
      test('AuthAuthenticated contains user and supports value equality', () {
        const user1 = User(
          id: 'user-1',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );
        const user2 = User(
          id: 'user-1',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );
        final state1 = AuthAuthenticated(user1);
        final state2 = AuthAuthenticated(user2);

        expect(state1, equals(state2));
        expect(state1.props, [user1]);
      });

      test('AuthFailure contains message and supports value equality', () {
        final state1 = AuthFailure('Error message');
        final state2 = AuthFailure('Error message');
        final state3 = AuthFailure('Different error');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state1.props, ['Error message']);
      });

      test('AuthUnauthenticated supports value equality', () {
        final state1 = AuthUnauthenticated();
        final state2 = AuthUnauthenticated();

        expect(state1, equals(state2));
      });

      test('AuthLoading supports value equality', () {
        final state1 = AuthLoading();
        final state2 = AuthLoading();

        expect(state1, equals(state2));
      });
    });

    group('AuthEvent', () {
      test('AuthCheckRequested has correct props', () {
        final event1 = AuthCheckRequested();
        final event2 = AuthCheckRequested();

        expect(event1.props, isEmpty);
        expect(event1, equals(event2));
      });

      test('AuthSignOutRequested has correct props', () {
        final event1 = AuthSignOutRequested();
        final event2 = AuthSignOutRequested();

        expect(event1.props, isEmpty);
        expect(event1, equals(event2));
      });
    });
  });
}
