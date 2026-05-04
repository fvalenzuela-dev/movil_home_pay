import '../entities/category.dart';

/// Category repository interface
abstract class CategoryRepository {
  /// Get all categories (paginated)
  Future<List<Category>> getCategories({int page = 1, int limit = 20});

  /// Get a single category by ID
  Future<Category> getCategoryById(int id);

  /// Create a new category
  Future<Category> createCategory(String name, {String? iconApk, String? colorApk});

  /// Update a category
  Future<Category> updateCategory(int id, String name, {String? iconApk, String? colorApk});

  /// Delete a category (soft delete)
  Future<void> deleteCategory(int id);
}
