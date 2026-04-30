/// API response builder for testing data sources and repositories
class ApiResponseBuilder {
  /// Creates a successful API response wrapper
  static Map<String, dynamic> success({
    dynamic data,
    String? message,
    int? statusCode,
  }) {
    return {
      'success': true,
      'data': data,
      if (message != null) 'message': message,
      if (statusCode != null) 'status_code': statusCode,
    };
  }

  /// Creates an error API response
  static Map<String, dynamic> error({
    required String message,
    int? code,
    dynamic details,
  }) {
    return {
      'success': false,
      'error': message,
      if (code != null) 'code': code,
      if (details != null) 'details': details,
    };
  }

  /// Creates a paginated list response
  static Map<String, dynamic> paginatedList({
    required List<Map<String, dynamic>> items,
    required int totalCount,
    int currentPage = 1,
    int totalPages = 1,
    String dataKey = 'data',
  }) {
    return {
      'success': true,
      dataKey: items,
      'total_count': totalCount,
      'current_page': currentPage,
      'total_pages': totalPages,
    };
  }

  /// Creates an empty list response
  static Map<String, dynamic> emptyList({String dataKey = 'data'}) {
    return {
      'success': true,
      dataKey: [],
      'total_count': 0,
      'current_page': 1,
      'total_pages': 0,
    };
  }

  /// Creates a malformed response (missing expected fields)
  static Map<String, dynamic> malformed({String? partialData}) {
    return {
      'success': true,
      if (partialData != null) 'items': partialData,
      // missing expected fields like 'data', 'total_count', etc.
    };
  }

  /// Creates a response with null data
  static Map<String, dynamic> nullData() {
    return {
      'success': true,
      'data': null,
    };
  }

  /// Creates a response with unexpected data structure
  static Map<String, dynamic> unexpectedStructure() {
    return {
      'result': 'ok',
      'records': [
        {'id': 1, 'name': 'Item 1'},
        {'id': 2, 'name': 'Item 2'},
      ],
    };
  }

  /// User-specific response builders
  static Map<String, dynamic> userResponse({
    required String userId,
    required String email,
    String? firstName,
    String? lastName,
    String? imageUrl,
  }) {
    return success(data: {
      'id': userId,
      'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (imageUrl != null) 'image_url': imageUrl,
    });
  }

  /// Cuenta list response builder
  static Map<String, dynamic> cuentaListResponse(List<Map<String, dynamic>> cuentas) {
    return success(data: cuentas);
  }

  /// Empresa paginated response builder
  static Map<String, dynamic> empresaPaginatedResponse({
    required List<Map<String, dynamic>> empresas,
    required int total,
    int page = 1,
    int pageSize = 20,
  }) {
    return {
      'success': true,
      'companies': empresas,
      'total_count': total,
      'current_page': page,
      'total_pages': (total / pageSize).ceil(),
    };
  }

  /// Category response builder
  static Map<String, dynamic> categoryResponse({
    required int id,
    required String name,
    String? iconName,
  }) {
    return success(data: {
      'id': id,
      'name': name,
      if (iconName != null) 'icon_name': iconName,
    });
  }

  /// Creates a 401 Unauthorized response
  static Map<String, dynamic> unauthorized() {
    return error(message: 'Unauthorized', code: 401);
  }

  /// Creates a 404 Not Found response
  static Map<String, dynamic> notFound({String? message}) {
    return error(message: message ?? 'Resource not found', code: 404);
  }

  /// Creates a 500 Server Error response
  static Map<String, dynamic> serverError({String? message}) {
    return error(message: message ?? 'Internal server error', code: 500);
  }

  /// Creates a validation error response
  static Map<String, dynamic> validationError({
    required List<Map<String, dynamic>> errors,
  }) {
    return error(
      message: 'Validation failed',
      code: 422,
      details: errors,
    );
  }
}