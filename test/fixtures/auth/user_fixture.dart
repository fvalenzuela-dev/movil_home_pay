import 'package:movil_home_pay/features/auth/domain/entities/user.dart';

/// User test fixture factory
class UserFixture {
  /// Creates a valid user with all fields populated
  static User createValidUser({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? 'user_123',
      email: email ?? 'test@example.com',
      firstName: firstName ?? 'John',
      lastName: lastName ?? 'Doe',
      imageUrl: imageUrl ?? 'https://example.com/avatar.png',
      createdAt: createdAt ?? DateTime(2024, 1, 15),
    );
  }

  /// Creates a user with only required fields (no optional)
  static User createMinimalUser() {
    return User(
      id: 'user_minimal',
      email: 'minimal@example.com',
    );
  }

  /// Creates a user with only firstName (no lastName)
  static User createUserWithOnlyFirstName() {
    return User(
      id: 'user_first_only',
      email: 'first@example.com',
      firstName: 'Jane',
    );
  }

  /// Creates a user with only lastName (no firstName)
  static User createUserWithOnlyLastName() {
    return User(
      id: 'user_last_only',
      email: 'last@example.com',
      lastName: 'Smith',
    );
  }

  /// Creates a user with null firstName and lastName (falls back to email)
  static User createUserWithNoNames() {
    return User(
      id: 'user_no_names',
      email: 'noname@example.com',
    );
  }

  /// Creates an admin user
  static User createAdminUser() {
    return User(
      id: 'admin_001',
      email: 'admin@example.com',
      firstName: 'Admin',
      lastName: 'User',
      imageUrl: 'https://example.com/admin.png',
      createdAt: DateTime(2024, 1, 1),
    );
  }

  /// Creates a list of multiple users for list tests
  static List<User> createUserList({int count = 3}) {
    return List.generate(count, (index) {
      return User(
        id: 'user_$index',
        email: 'user$index@example.com',
        firstName: 'User',
        lastName: '$index',
      );
    });
  }

  /// Creates a user with specific ID for specific lookup tests
  static User createUserWithId(String id) {
    return User(
      id: id,
      email: '${id}_@example.com',
      firstName: 'Test',
      lastName: 'User',
    );
  }
}