import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';

/// Empresa test fixture factory
class EmpresaFixture {
  /// Creates a valid empresa with all fields populated
  static Empresa createValidEmpresa({
    String? id,
    String? authUserId,
    int? categoryId,
    String? name,
    String? website,
    String? phone,
    bool? isActive,
  }) {
    return Empresa(
      id: id ?? 'emp_001',
      authUserId: authUserId ?? 'user_123',
      categoryId: categoryId ?? 1,
      name: name ?? 'Netflix',
      website: website ?? 'https://netflix.com',
      phone: phone ?? '+56912345678',
      isActive: isActive ?? true,
    );
  }

  /// Creates a minimal empresa with only required fields
  static Empresa createMinimalEmpresa() {
    return Empresa(
      id: 'emp_minimal',
      authUserId: 'user_123',
      categoryId: 1,
      name: 'Spotify',
    );
  }

  /// Creates an inactive empresa
  static Empresa createInactiveEmpresa() {
    return Empresa(
      id: 'emp_inactive',
      authUserId: 'user_123',
      categoryId: 2,
      name: 'Old Company',
      isActive: false,
    );
  }

  /// Creates an empresa without optional fields
  static Empresa createEmpresaWithoutOptional() {
    return Empresa(
      id: 'emp_no_optional',
      authUserId: 'user_456',
      categoryId: 3,
      name: 'Basic Service',
    );
  }

  /// Creates empresa for streaming category
  static Empresa createStreamingEmpresa() {
    return Empresa(
      id: 'emp_streaming',
      authUserId: 'user_123',
      categoryId: 10,
      name: 'Disney Plus',
      website: 'https://disneyplus.com',
      phone: '+56987654321',
      isActive: true,
    );
  }

  /// Creates empresa for utilities category
  static Empresa createUtilitiesEmpresa() {
    return Empresa(
      id: 'emp_utilities',
      authUserId: 'user_123',
      categoryId: 4, // luz/electricidad
      name: 'Enel',
      phone: '+56911223344',
      isActive: true,
    );
  }

  /// Creates an empresa from JSON map (for testing JSON parsing)
  static Map<String, dynamic> createEmpresaJson({
    String? id,
    String? authUserId,
    int? categoryId,
    String? name,
    String? website,
    String? phone,
    bool? isActive,
  }) {
    return {
      'id': id ?? 'emp_json',
      'auth_user_id': authUserId ?? 'user_123',
      'category_id': categoryId ?? 1,
      'name': name ?? 'JSON Company',
      ...?website != null ? {'website': website} : null,
      ...?phone != null ? {'phone': phone} : null,
      'is_active': isActive ?? true,
    };
  }

  /// Creates a list of empresas for list tests
  static List<Empresa> createEmpresaList({int count = 3}) {
    return List.generate(count, (index) {
      return Empresa(
        id: 'emp_$index',
        authUserId: 'user_123',
        categoryId: index + 1,
        name: 'Company $index',
        isActive: true,
      );
    });
  }

  /// Creates an empresa with specific ID for lookup tests
  static Empresa createEmpresaWithId(String id) {
    return Empresa(
      id: id,
      authUserId: 'user_specific',
      categoryId: 1,
      name: 'Specific Company',
    );
  }
}