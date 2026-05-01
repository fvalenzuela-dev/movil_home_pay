import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

/// Estados del CategoryBloc
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class CategoryInitial extends CategoryState {}

/// Cargando categorías
class CategoryLoading extends CategoryState {}

/// Categorías cargadas exitosamente
class CategoriesLoaded extends CategoryState {
  final List<Category> categories;
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Error al cargar/processar categorías
class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Categoría creada exitosamente
class CategoryCreated extends CategoryState {
  final Category category;
  const CategoryCreated(this.category);

  @override
  List<Object?> get props => [category];
}

/// Categoría actualizada exitosamente
class CategoryUpdated extends CategoryState {
  final Category category;
  const CategoryUpdated(this.category);

  @override
  List<Object?> get props => [category];
}

/// Categoría eliminada exitosamente
class CategoryDeleted extends CategoryState {
  final int id;
  const CategoryDeleted(this.id);

  @override
  List<Object?> get props => [id];
}
