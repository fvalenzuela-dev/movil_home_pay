import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../domain/entities/empresa.dart';
import '../../domain/repositories/empresa_repository.dart';

/// Datasource for empresa API operations with validation and sanitization
class EmpresaDatasource {
  final Dio _dio;

  EmpresaDatasource(this._dio);

  /// Sanitizes ID to prevent injection attacks
  static String _sanitizarId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('ID no puede estar vacío');
    }
    // Only allow alphanumeric characters, dashes, and underscores (UUID format)
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

  /// Validates that category_id is a positive integer
  static void _validarCategoryId(int categoryId) {
    if (categoryId <= 0) {
      throw ArgumentError('category_id debe ser positivo');
    }
  }

  /// Sanitizes website URL if provided
  static String? _sanitizarWebsite(String? website) {
    if (website == null || website.trim().isEmpty) {
      return null;
    }
    final trimmed = website.trim();
    // Basic URL validation - must start with http:// or https://
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      throw ArgumentError('URL de sitio web inválida');
    }
    return trimmed;
  }

  /// GET /companies - List companies with pagination
  Future<PaginatedResult<Empresa>> getCompanies({int page = 1, int pageSize = 20}) async {
    final response = await _dio.get(
      ApiConfig.companiesUrl(page: page, pageSize: pageSize),
    );

    return PaginatedResult.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Empresa.fromJson(json),
    );
  }

  /// GET /companies/{id} - Get single company by ID
  Future<Empresa> getCompanyById(String id) async {
    final sanitizedId = _sanitizarId(id);

    final response = await _dio.get(
      '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/$sanitizedId',
    );

    final data = response.data;
    if (data == null) {
      throw ArgumentError('Empresa no encontrada');
    }

    // Backend wraps response in "data" field
    final empresaData = data['data'] ?? data;
    return Empresa.fromJson(empresaData as Map<String, dynamic>);
  }

  /// POST /companies - Create new company
  Future<Empresa> createCompany(Empresa empresa) async {
    _validarNombre(empresa.name);
    _validarCategoryId(empresa.categoryId);

    final website = _sanitizarWebsite(empresa.website);

    final data = {
      'auth_user_id': empresa.authUserId,
      'category_id': empresa.categoryId,
      'name': empresa.name.trim(),
      if (website != null) 'website': website,
      if (empresa.phone != null) 'phone': empresa.phone,
      'is_active': empresa.isActive,
    };

    final response = await _dio.post(
      '${ApiConfig.baseUrl}${ApiConfig.companiesPath}',
      data: data,
    );

    final responseData = response.data['data'] ?? response.data;
    return Empresa.fromJson(responseData as Map<String, dynamic>);
  }

  /// PUT /companies/{id} - Update existing company
  Future<Empresa> updateCompany(Empresa empresa) async {
    _sanitizarId(empresa.id);
    _validarNombre(empresa.name);
    _validarCategoryId(empresa.categoryId);

    final website = _sanitizarWebsite(empresa.website);

    final data = {
      'category_id': empresa.categoryId,
      'name': empresa.name.trim(),
      if (website != null) 'website': website,
      if (empresa.phone != null) 'phone': empresa.phone,
      'is_active': empresa.isActive,
    };

    final response = await _dio.put(
      '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/${empresa.id}',
      data: data,
    );

    final responseData = response.data['data'] ?? response.data;
    return Empresa.fromJson(responseData as Map<String, dynamic>);
  }

  /// DELETE /companies/{id} - Delete company
  Future<bool> deleteCompany(String id) async {
    final sanitizedId = _sanitizarId(id);

    await _dio.delete(
      '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/$sanitizedId',
    );

    return true;
  }
}