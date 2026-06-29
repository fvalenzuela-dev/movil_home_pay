import 'package:equatable/equatable.dart';

/// Account entity representing a master billing account
class Account extends Equatable {
  final String id;
  final String companyId;
  final String? companyName;
  final String name;
  final String? accountNumber;
  final int billingDay;
  final bool autoAccumulate;
  final String? groupId;
  final bool isActive;
  final String? createdAt;
  final String? deletedAt;

  const Account({
    required this.id,
    required this.companyId,
    this.companyName,
    required this.name,
    this.accountNumber,
    required this.billingDay,
    required this.autoAccumulate,
    this.groupId,
    this.isActive = true,
    this.createdAt,
    this.deletedAt,
  });

  /// Factory constructor for creating from JSON API response (snake_case keys)
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      companyName: json['company_name'],
      name: json['name'] ?? '',
      accountNumber: json['account_number'],
      billingDay: json['billing_day'] ?? 0,
      autoAccumulate: json['auto_accumulate'] ?? false,
      groupId: json['group_id'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
    );
  }

  /// Convert to JSON for API requests (snake_case keys)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'company_name': companyName,
      'name': name,
      'account_number': accountNumber,
      'billing_day': billingDay,
      'auto_accumulate': autoAccumulate,
      'group_id': groupId,
      'is_active': isActive,
      'created_at': createdAt,
      'deleted_at': deletedAt,
    };
  }

  /// Create a copy with modified fields
  Account copyWith({
    String? id,
    String? companyId,
    String? companyName,
    String? name,
    String? accountNumber,
    int? billingDay,
    bool? autoAccumulate,
    String? groupId,
    bool? isActive,
    String? createdAt,
    String? deletedAt,
  }) {
    return Account(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      billingDay: billingDay ?? this.billingDay,
      autoAccumulate: autoAccumulate ?? this.autoAccumulate,
      groupId: groupId ?? this.groupId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        companyName,
        name,
        accountNumber,
        billingDay,
        autoAccumulate,
        groupId,
        isActive,
        createdAt,
        deletedAt,
      ];
}
