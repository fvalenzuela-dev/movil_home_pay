import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_datasource.dart';

/// Account repository implementation — thin delegation to datasource
class AccountRepositoryImpl implements AccountRepository {
  final AccountDatasource _datasource;

  AccountRepositoryImpl(this._datasource);

  @override
  Future<PaginatedResult<Account>> getAccounts({
    String? companyId,
    String? sort,
    String? order,
    int page = 1,
    int limit = 20,
  }) {
    return _datasource.getAccounts(
      companyId: companyId,
      sort: sort,
      order: order,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Account> getAccountById(String id) {
    return _datasource.getAccountById(id);
  }

  @override
  Future<Account> createAccount(Account account) {
    return _datasource.createAccount(account);
  }

  @override
  Future<Account> updateAccount(Account account) {
    return _datasource.updateAccount(account);
  }

  @override
  Future<bool> deleteAccount(String id) {
    return _datasource.deleteAccount(id);
  }
}
