import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../domain/entities/category.dart';

/// Datasource que consume la API de categories
class CategoryDatasource {
  final Dio _dio;

  CategoryDatasource(this._dio);

  /// GET /categories
  Future<List<Category>> getCategories({int page = 1, int limit = 20}) async {
    final response = await _dio.get(
      '${ApiConfig.baseUrl}/categories',
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data;
    final List<dynamic> items = data['data'] ?? data['categories'] ?? data['items'] ?? [];
    return items.map((json) => _fromJson(json)).toList();
  }

  /// GET /categories/{id}
  Future<Category> getCategoryById(int id) async {
    final response = await _dio.get('${ApiConfig.baseUrl}/categories/$id');
    return _fromJson(response.data);
  }

  /// POST /categories
  Future<Category> createCategory(String name) async {
    final response = await _dio.post(
      '${ApiConfig.baseUrl}/categories',
      data: {'name': name},
    );
    return _fromJson(response.data);
  }

  /// PUT /categories/{id}
  Future<Category> updateCategory(int id, String name) async {
    final response = await _dio.put(
      '${ApiConfig.baseUrl}/categories/$id',
      data: {'name': name},
    );
    return _fromJson(response.data);
  }

  /// DELETE /categories/{id}
  Future<void> deleteCategory(int id) async {
    await _dio.delete('${ApiConfig.baseUrl}/categories/$id');
  }

  Category _fromJson(Map<String, dynamic> json) {
    // La API puede devolver wrapper: { "data": { ... } } o directo { ... }
    final data = json['data'] ?? json;

    // La API puede devolver el ID directamente o dentro de un wrapper
    final idValue = data['id'] ?? json['id'];
    final int id;
    if (idValue is int) {
      id = idValue;
    } else if (idValue is String) {
      id = int.tryParse(idValue) ?? 0;
    } else {
      id = 0; // Fallback
    }

    return Category(
      id: id,
      name: data['name']?.toString() ?? json['name']?.toString() ?? '',
      createdAt: (data['created_at'] ?? json['created_at']) != null
          ? DateTime.tryParse((data['created_at'] ?? json['created_at']).toString())
          : null,
      updatedAt: (data['updated_at'] ?? json['updated_at']) != null
          ? DateTime.tryParse((data['updated_at'] ?? json['updated_at']).toString())
          : null,
    );
  }
}
