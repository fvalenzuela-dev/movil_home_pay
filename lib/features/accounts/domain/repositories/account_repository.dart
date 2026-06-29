import '../entities/account.dart';
// Reuse PaginatedResult<T> from empresas (ADR-1 — no duplication, zero new files)
import '../../../empresas/domain/repositories/empresa_repository.dart';

export '../../../empresas/domain/repositories/empresa_repository.dart' show PaginatedResult;

/// Account repository interface
abstract class AccountRepository {
  /// Get paginated list of accounts
  Future<PaginatedResult<Account>> getAccounts({
    String? companyId,
    String? sort,
    String? order,
    int page = 1,
    int limit = 20,
  });

  /// Get a single account by ID
  Future<Account> getAccountById(String id);

  /// Create a new account
  Future<Account> createAccount(Account account);

  /// Update an existing account (PUT)
  Future<Account> updateAccount(Account account);

  /// Soft delete an account (DELETE returns 204 → true)
  Future<bool> deleteAccount(String id);
}
