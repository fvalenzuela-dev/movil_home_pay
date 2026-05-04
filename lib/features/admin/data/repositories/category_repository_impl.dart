import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_datasource.dart';

/// Implementación de CategoryRepository
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource _datasource;

  CategoryRepositoryImpl(this._datasource);

  @override
  Future<List<Category>> getCategories({int page = 1, int limit = 20}) {
    return _datasource.getCategories(page: page, limit: limit);
  }

  @override
  Future<Category> getCategoryById(int id) {
    return _datasource.getCategoryById(id);
  }

  @override
  Future<Category> createCategory(String name, {String? iconApk, String? colorApk}) {
    return _datasource.createCategory(name, iconApk: iconApk, colorApk: colorApk);
  }

  @override
  Future<Category> updateCategory(int id, String name, {String? iconApk, String? colorApk}) {
    return _datasource.updateCategory(id, name, iconApk: iconApk, colorApk: colorApk);
  }

  @override
  Future<void> deleteCategory(int id) {
    return _datasource.deleteCategory(id);
  }
}
