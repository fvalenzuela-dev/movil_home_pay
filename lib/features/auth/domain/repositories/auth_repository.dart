import '../entities/user.dart';

/// Auth repository interface
abstract class AuthRepository {
  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Sign in with credentials
  Future<User> signIn({required String email, required String password});

  /// Sign up new user
  Future<User> signUp({required String email, required String password});

  /// Sign out current user
  Future<void> signOut();
}
