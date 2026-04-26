import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Configuration for Movil Home Pay
class ApiConfig {
  /// Base URL for the REST API
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8082';

  /// Request timeout in milliseconds
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// Endpoints
  static const String periodsPath = '/periods';
  static const String billingsPath = '/billings';

  /// Build URL para billings de un periodo
  static String periodBillingsUrl(String period) =>
      '$baseUrl$periodsPath/$period$billingsPath';
}
