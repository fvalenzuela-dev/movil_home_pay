import '../entities/empresa.dart';

/// Paginated result wrapper for list operations
class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsList = json['data'] ?? json['items'] ?? json['companies'] ?? [];
    return PaginatedResult(
      items: (itemsList as List).map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      totalCount: json['total_count'] ?? json['total'] ?? 0,
      currentPage: json['current_page'] ?? json['page'] ?? 1,
      totalPages: json['total_pages'] ?? json['total_pages'] ?? 1,
    );
  }
}

/// Empresa repository interface
abstract class EmpresaRepository {
  /// Get paginated list of companies for the current user
  Future<PaginatedResult<Empresa>> getCompanies({int page = 1, int pageSize = 20});

  /// Get a single company by ID
  Future<Empresa> getCompanyById(String id);

  /// Create a new company
  Future<Empresa> createCompany(Empresa empresa);

  /// Update an existing company
  Future<Empresa> updateCompany(Empresa empresa);

  /// Delete a company by ID
  Future<bool> deleteCompany(String id);
}