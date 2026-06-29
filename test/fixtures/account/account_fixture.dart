import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';

/// Account test fixture factory
class AccountFixture {
  /// Creates a valid Account with all fields populated
  static Account createValidAccount({
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
      id: id ?? 'acc-001',
      companyId: companyId ?? 'comp-001',
      companyName: companyName ?? 'Test Company',
      name: name ?? 'Netflix Monthly',
      accountNumber: accountNumber ?? 'ACC-0001',
      billingDay: billingDay ?? 15,
      autoAccumulate: autoAccumulate ?? false,
      groupId: groupId,
      isActive: isActive ?? true,
      createdAt: createdAt ?? '2024-01-01T00:00:00Z',
      deletedAt: deletedAt,
    );
  }

  /// Creates a minimal Account with only required fields
  static Account createMinimalAccount() {
    return const Account(
      id: 'acc-minimal',
      companyId: 'comp-001',
      companyName: 'Test Company',
      name: 'Minimal Account',
      accountNumber: '',
      billingDay: 1,
      autoAccumulate: false,
      isActive: true,
    );
  }

  /// Creates an inactive Account
  static Account createInactiveAccount() {
    return const Account(
      id: 'acc-inactive',
      companyId: 'comp-001',
      companyName: 'Test Company',
      name: 'Inactive Account',
      accountNumber: 'ACC-INACT',
      billingDay: 10,
      autoAccumulate: false,
      isActive: false,
    );
  }

  /// Creates an Account JSON map (all 11 snake_case fields)
  static Map<String, dynamic> createAccountJson({
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
    final map = <String, dynamic>{
      'id': id ?? 'acc-json',
      'company_id': companyId ?? 'comp-001',
      'company_name': companyName ?? 'JSON Company',
      'name': name ?? 'JSON Account',
      'account_number': accountNumber ?? 'ACC-JSON',
      'billing_day': billingDay ?? 15,
      'auto_accumulate': autoAccumulate ?? false,
      'is_active': isActive ?? true,
    };
    if (groupId != null) map['group_id'] = groupId;
    if (createdAt != null) map['created_at'] = createdAt;
    if (deletedAt != null) map['deleted_at'] = deletedAt;
    return map;
  }

  /// Creates a list of Accounts for list tests
  static List<Account> createAccountList({int count = 3}) {
    return List.generate(count, (index) {
      return Account(
        id: 'acc-$index',
        companyId: 'comp-001',
        companyName: 'Company $index',
        name: 'Account $index',
        accountNumber: 'ACC-$index',
        billingDay: index + 1,
        autoAccumulate: false,
        isActive: true,
      );
    });
  }
}
