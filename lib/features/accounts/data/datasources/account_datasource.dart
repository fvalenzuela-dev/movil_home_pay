import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

/// Datasource for account API operations with validation and sanitization
class AccountDatasource {
  final Dio _dio;

  AccountDatasource(this._dio);

  /// Sanitizes ID to prevent injection attacks — must be non-empty UUID-like string
  static String _sanitizarId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('ID no puede estar vacío');
    }
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id)) {
      throw ArgumentError('ID contiene caracteres inválidos');
    }
    return id;
  }

  /// Validates that name is not empty or whitespace only
  static void _validarNombre(String nombre) {
    if (nombre.trim().isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío');
    }
  }

  /// Validates that companyId is non-empty (required FK on create)
  static void _validarCompanyId(String companyId) {
    if (companyId.trim().isEmpty) {
      throw ArgumentError('company_id es requerido');
    }
  }

  /// GET /accounts — paginated list of accounts
  Future<PaginatedResult<Account>> getAccounts({
    String? companyId,
    String? sort,
    String? order,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConfig.accountsUrl(
        companyId: companyId,
        sort: sort,
        order: order,
        page: page,
        limit: limit,
      ),
    );

    return PaginatedResult.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Account.fromJson(json),
    );
  }

  /// GET /accounts/{id} — returns account, parses from root (defensive data unwrap)
  Future<Account> getAccountById(String id) async {
    _sanitizarId(id);

    final response = await _dio.get(ApiConfig.accountUrl(id));

    final data = response.data;
    if (data == null) {
      throw ArgumentError('Account no encontrada');
    }

    // Spec says direct root response; defensive unwrap tolerates {data: {...}} shape
    final accountData = data['data'] ?? data;
    return Account.fromJson(accountData as Map<String, dynamic>);
  }

  /// POST /accounts — create new account
  Future<Account> createAccount(Account account) async {
    _validarCompanyId(account.companyId);
    _validarNombre(account.name);

    final body = {
      'company_id': account.companyId,
      'name': account.name.trim(),
      if (account.accountNumber != null && account.accountNumber!.isNotEmpty)
        'account_number': account.accountNumber,
      'billing_day': account.billingDay,
      'auto_accumulate': account.autoAccumulate,
      if (account.groupId != null) 'group_id': account.groupId,
    };

    final response = await _dio.post(
      ApiConfig.accountsPath,
      data: body,
    );

    final responseData = response.data['data'] ?? response.data;
    return Account.fromJson(responseData as Map<String, dynamic>);
  }

  /// PUT /accounts/{id} — update existing account
  Future<Account> updateAccount(Account account) async {
    _sanitizarId(account.id);

    final body = {
      'name': account.name,
      'billing_day': account.billingDay,
      'auto_accumulate': account.autoAccumulate,
      if (account.accountNumber != null) 'account_number': account.accountNumber,
      'company_id': account.companyId,
      if (account.groupId != null) 'group_id': account.groupId,
    };

    final response = await _dio.put(
      ApiConfig.accountUrl(account.id),
      data: body,
    );

    final responseData = response.data['data'] ?? response.data;
    return Account.fromJson(responseData as Map<String, dynamic>);
  }

  /// DELETE /accounts/{id} — soft delete, 204 → true
  Future<bool> deleteAccount(String id) async {
    _sanitizarId(id);

    await _dio.delete(ApiConfig.accountUrl(id));

    return true;
  }
}
