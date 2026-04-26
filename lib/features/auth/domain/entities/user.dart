import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.createdAt,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? email;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    imageUrl,
    createdAt,
  ];
}
