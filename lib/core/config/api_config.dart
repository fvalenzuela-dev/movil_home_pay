import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Configuration for Movil Home Pay
class ApiConfig {
  /// Base URL for the REST API
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? Platform.environment['API_BASE_URL'] ?? 'http://localhost:8082';

  /// Request timeout in milliseconds
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// Endpoints
  static const String periodsPath = '/periods';
  static const String billingsPath = '/billings';
  static const String companiesPath = '/companies';

  /// Build URL para billings de un periodo
  static String periodBillingsUrl(String period) =>
      '$baseUrl$periodsPath/$period$billingsPath';

  /// Build URL para abrir todas las cuentas de un periodo (POST /periods/{period}/open)
  static String periodOpenUrl(String period) =>
      '$baseUrl$periodsPath/$period/open';

  /// Build URL para companies con pagination
  static String companiesUrl({int page = 1, int pageSize = 20}) =>
      '$baseUrl$companiesPath?page=$page&page_size=$pageSize';

  /// Direct billing endpoint: GET /billings/{billingId}
  static String billingUrl(String billingId) =>
      '$baseUrl$billingsPath/$billingId';

  /// Accounts endpoint path
  static const String accountsPath = '/accounts';

  /// Build URL for accounts list with pagination and filters
  /// NOTE: pagination param is `limit`, NOT page_size (differs from companiesUrl)
  static String accountsUrl({
    String? companyId,
    String? sort,
    String? order,
    int page = 1,
    int limit = 20,
  }) {
    final params = <String, String>{'page': '$page', 'limit': '$limit'};
    if (companyId != null && companyId.isNotEmpty) params['company_id'] = companyId;
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (order != null && order.isNotEmpty) params['order'] = order;
    final qs = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$baseUrl$accountsPath?$qs';
  }

  /// Build URL for a single account by ID
  static String accountUrl(String id) => '$baseUrl$accountsPath/$id';
}
