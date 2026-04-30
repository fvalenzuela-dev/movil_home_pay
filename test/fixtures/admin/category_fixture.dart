import 'package:movil_home_pay/features/admin/domain/entities/category.dart';

/// Category test fixture factory
class CategoryFixture {
  /// Creates a valid category with all fields populated
  static Category createValidCategory({
    int? id,
    String? name,
    String? iconName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? 1,
      name: name ?? 'Streaming',
      iconName: iconName ?? 'netflix',
      createdAt: createdAt ?? DateTime(2024, 1, 15),
      updatedAt: updatedAt ?? DateTime(2024, 1, 15),
    );
  }

  /// Creates a minimal category with only required fields
  static Category createMinimalCategory() {
    return const Category(
      id: 99,
      name: 'Basic Category',
    );
  }

  /// Creates a category with null iconName
  static Category createCategoryWithoutIcon() {
    return Category(
      id: 2,
      name: 'Utilities',
      iconName: null,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  /// Creates a streaming category
  static Category createStreamingCategory() {
    return Category(
      id: 10,
      name: 'Netflix',
      iconName: 'netflix',
      createdAt: DateTime(2024, 1, 1),
    );
  }

  /// Creates a utilities category
  static Category createUtilitiesCategory() {
    return Category(
      id: 4,
      name: 'Electricidad',
      iconName: 'luz',
      createdAt: DateTime(2024, 1, 1),
    );
  }

  /// Creates a water category
  static Category createWaterCategory() {
    return Category(
      id: 5,
      name: 'Agua',
      iconName: 'agua',
      createdAt: DateTime(2024, 1, 1),
    );
  }

  /// Creates a list of categories for list tests
  static List<Category> createCategoryList({int count = 3}) {
    final icons = ['netflix', 'spotify', 'agua', 'luz', 'gas'];
    return List.generate(count, (index) {
      return Category(
        id: index + 1,
        name: 'Category $index',
        iconName: icons[index % icons.length],
        createdAt: DateTime(2024, 1, index + 1),
      );
    });
  }

  /// Creates category JSON map for datasource parsing tests
  static Map<String, dynamic> createCategoryJson({
    int? id,
    String? name,
    String? iconName,
    String? createdAt,
    String? updatedAt,
  }) {
    return {
      'id': id ?? 1,
      'name': name ?? 'Test Category',
      if (iconName != null) 'icon_name': iconName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  /// Creates a category with specific ID for lookup tests
  static Category createCategoryWithId(int id) {
    return Category(
      id: id,
      name: 'Specific Category $id',
      iconName: 'star',
      createdAt: DateTime(2024, 1, 1),
    );
  }

  /// Creates an updated category (with updatedAt > createdAt)
  static Category createUpdatedCategory() {
    final created = DateTime(2024, 1, 1);
    return Category(
      id: 1,
      name: 'Updated Category',
      iconName: 'refresh',
      createdAt: created,
      updatedAt: DateTime(2024, 6, 15),
    );
  }
}