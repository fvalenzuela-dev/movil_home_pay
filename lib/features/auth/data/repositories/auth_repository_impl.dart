import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/clerk_datasource.dart';

/// Auth repository implementation
class AuthRepositoryImpl implements AuthRepository {
  // TODO: Implementar con Clerk SDK - por ahora se usa clerk_flutter widget
  // final ClerkDatasource _datasource;
  // AuthRepositoryImpl(this._datasource);

  AuthRepositoryImpl(ClerkDatasource datasource);

  @override
  Future<User?> getCurrentUser() async {
    // TODO: Implement with Clerk SDK
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    // TODO: Implement with Clerk SDK
    throw UnimplementedError('Use Clerk widget for sign-in');
  }

  @override
  Future<User> signUp({required String email, required String password}) async {
    // TODO: Implement with Clerk SDK
    throw UnimplementedError('Use Clerk widget for sign-up');
  }

  @override
  Future<void> signOut() async {
    // TODO: Implement with Clerk SDK
  }
}
