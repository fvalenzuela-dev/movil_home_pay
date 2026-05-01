import 'package:equatable/equatable.dart';

/// Empresa entity representing a company for bill payment categorization
class Empresa extends Equatable {
  final String id;
  final String authUserId;
  final int categoryId;
  final String? categoryName;
  final String name;
  final String? website;
  final String? phone;
  final bool isActive;

  const Empresa({
    required this.id,
    required this.authUserId,
    required this.categoryId,
    this.categoryName,
    required this.name,
    this.website,
    this.phone,
    this.isActive = true,
  });

  /// Factory constructor for creating from JSON API response
  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'] ?? '',
      authUserId: json['auth_user_id'] ?? '',
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? json['category']?['name'],
      name: json['name'] ?? '',
      website: json['website'],
      phone: json['phone'],
      isActive: json['is_active'] ?? true,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'category_id': categoryId,
      'name': name,
      if (website != null) 'website': website,
      if (phone != null) 'phone': phone,
      'is_active': isActive,
    };
  }

  /// Create a copy with modified fields
  Empresa copyWith({
    String? id,
    String? authUserId,
    int? categoryId,
    String? categoryName,
    String? name,
    String? website,
    String? phone,
    bool? isActive,
  }) {
    return Empresa(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      name: name ?? this.name,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        authUserId,
        categoryId,
        categoryName,
        name,
        website,
        phone,
        isActive,
      ];
}