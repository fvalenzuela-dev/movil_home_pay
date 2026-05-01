import '../../domain/entities/empresa.dart';
import '../../domain/repositories/empresa_repository.dart';
import '../datasources/empresa_datasource.dart';

/// Empresa repository implementation
class EmpresaRepositoryImpl implements EmpresaRepository {
  final EmpresaDatasource _datasource;

  EmpresaRepositoryImpl(this._datasource);

  @override
  Future<PaginatedResult<Empresa>> getCompanies({int page = 1, int pageSize = 20}) {
    return _datasource.getCompanies(page: page, pageSize: pageSize);
  }

  @override
  Future<Empresa> getCompanyById(String id) {
    return _datasource.getCompanyById(id);
  }

  @override
  Future<Empresa> createCompany(Empresa empresa) {
    return _datasource.createCompany(empresa);
  }

  @override
  Future<Empresa> updateCompany(Empresa empresa) {
    return _datasource.updateCompany(empresa);
  }

  @override
  Future<bool> deleteCompany(String id) {
    return _datasource.deleteCompany(id);
  }
}