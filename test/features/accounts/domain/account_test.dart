import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';

void main() {
  group('Account Entity', () {
    const testAccount = Account(
      id: 'acc-001',
      companyId: 'comp-001',
      companyName: 'Test Company',
      name: 'Netflix Monthly',
      accountNumber: 'ACC-0001',
      billingDay: 15,
      autoAccumulate: false,
      groupId: 'grp-1',
      isActive: true,
      createdAt: '2024-01-01T00:00:00Z',
      deletedAt: null,
    );

    test('creates Account with all fields', () {
      expect(testAccount.id, 'acc-001');
      expect(testAccount.companyId, 'comp-001');
      expect(testAccount.companyName, 'Test Company');
      expect(testAccount.name, 'Netflix Monthly');
      expect(testAccount.accountNumber, 'ACC-0001');
      expect(testAccount.billingDay, 15);
      expect(testAccount.autoAccumulate, false);
      expect(testAccount.groupId, 'grp-1');
      expect(testAccount.isActive, true);
      expect(testAccount.createdAt, '2024-01-01T00:00:00Z');
      expect(testAccount.deletedAt, isNull);
    });

    group('fromJson', () {
      test('parses all 11 fields with correct Dart types', () {
        final json = {
          'id': 'acc-001',
          'company_id': 'comp-001',
          'company_name': 'Test Company',
          'name': 'Netflix Monthly',
          'account_number': 'ACC-0001',
          'billing_day': 15,
          'auto_accumulate': true,
          'group_id': 'grp-1',
          'is_active': true,
          'created_at': '2024-01-01T00:00:00Z',
          'deleted_at': null,
        };

        final account = Account.fromJson(json);

        expect(account.id, 'acc-001');
        expect(account.companyId, 'comp-001');
        expect(account.companyName, 'Test Company');
        expect(account.name, 'Netflix Monthly');
        expect(account.accountNumber, 'ACC-0001');
        expect(account.billingDay, isA<int>());
        expect(account.billingDay, 15);
        expect(account.autoAccumulate, isA<bool>());
        expect(account.autoAccumulate, true);
        expect(account.groupId, 'grp-1');
        expect(account.isActive, true);
        expect(account.createdAt, '2024-01-01T00:00:00Z');
        expect(account.deletedAt, isNull);
      });

      test('maps snake_case keys to camelCase fields', () {
        final json = {
          'id': 'acc-1',
          'company_id': 'comp-1',
          'company_name': 'Company',
          'name': 'Account',
          'account_number': 'NUM',
          'billing_day': 10,
          'auto_accumulate': false,
          'is_active': true,
        };

        final account = Account.fromJson(json);

        expect(account.companyId, 'comp-1');
        expect(account.companyName, 'Company');
        expect(account.accountNumber, 'NUM');
        expect(account.billingDay, 10);
        expect(account.autoAccumulate, false);
        expect(account.isActive, true);
      });

      test('handles absent optional fields as null', () {
        final json = {
          'id': 'acc-1',
          'company_id': 'comp-1',
          'company_name': 'Company',
          'name': 'Account',
          'account_number': 'NUM',
          'billing_day': 5,
          'auto_accumulate': false,
          'is_active': true,
          // groupId, createdAt, deletedAt absent
        };

        final account = Account.fromJson(json);

        expect(account.groupId, isNull);
        expect(account.createdAt, isNull);
        expect(account.deletedAt, isNull);
      });
    });

    group('toJson', () {
      test('roundtrip produces same snake_case keys', () {
        final json = {
          'id': 'acc-001',
          'company_id': 'comp-001',
          'company_name': 'Test Company',
          'name': 'Netflix Monthly',
          'account_number': 'ACC-0001',
          'billing_day': 15,
          'auto_accumulate': false,
          'is_active': true,
        };

        final account = Account.fromJson(json);
        final result = account.toJson();

        expect(result['id'], 'acc-001');
        expect(result['company_id'], 'comp-001');
        expect(result['company_name'], 'Test Company');
        expect(result['name'], 'Netflix Monthly');
        expect(result['account_number'], 'ACC-0001');
        expect(result['billing_day'], 15);
        expect(result['auto_accumulate'], false);
        expect(result['is_active'], true);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated name; original unchanged', () {
        final updated = testAccount.copyWith(name: 'X');

        expect(updated.name, 'X');
        expect(testAccount.name, 'Netflix Monthly'); // original unchanged
        expect(updated.id, testAccount.id);
        expect(updated.companyId, testAccount.companyId);
      });

      test('keeps original values when no parameters provided', () {
        final copy = testAccount.copyWith();

        expect(copy.id, testAccount.id);
        expect(copy.companyId, testAccount.companyId);
        expect(copy.name, testAccount.name);
        expect(copy.billingDay, testAccount.billingDay);
      });

      test('can update billingDay', () {
        final updated = testAccount.copyWith(billingDay: 28);

        expect(updated.billingDay, 28);
        expect(testAccount.billingDay, 15);
      });
    });

    group('Equatable', () {
      test('two Account instances with identical fields are equal', () {
        const account1 = Account(
          id: 'acc-001',
          companyId: 'comp-001',
          companyName: 'Company',
          name: 'Netflix',
          accountNumber: 'ACC',
          billingDay: 15,
          autoAccumulate: false,
          isActive: true,
        );
        const account2 = Account(
          id: 'acc-001',
          companyId: 'comp-001',
          companyName: 'Company',
          name: 'Netflix',
          accountNumber: 'ACC',
          billingDay: 15,
          autoAccumulate: false,
          isActive: true,
        );

        expect(account1, equals(account2));
      });

      test('two Account instances with different ids are NOT equal', () {
        const account1 = Account(
          id: 'acc-001',
          companyId: 'comp-001',
          companyName: 'Company',
          name: 'Netflix',
          accountNumber: 'ACC',
          billingDay: 15,
          autoAccumulate: false,
          isActive: true,
        );
        const account2 = Account(
          id: 'acc-999',
          companyId: 'comp-001',
          companyName: 'Company',
          name: 'Netflix',
          accountNumber: 'ACC',
          billingDay: 15,
          autoAccumulate: false,
          isActive: true,
        );

        expect(account1, isNot(equals(account2)));
      });
    });
  });
}
