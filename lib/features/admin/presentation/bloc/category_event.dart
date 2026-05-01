import 'package:equatable/equatable.dart';

/// Eventos del CategoryBloc
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar todas las categorías
class CategoriesLoadRequested extends CategoryEvent {
  const CategoriesLoadRequested();
}

/// Crear una nueva categoría
class CategoryCreateRequested extends CategoryEvent {
  final String name;
  final String? iconName;
  const CategoryCreateRequested(this.name, [this.iconName]);

  @override
  List<Object?> get props => [name, iconName];
}

/// Actualizar una categoría existente
class CategoryUpdateRequested extends CategoryEvent {
  final int id;
  final String name;
  final String? iconName;
  const CategoryUpdateRequested(this.id, this.name, [this.iconName]);

  @override
  List<Object?> get props => [id, name, iconName];
}

/// Eliminar una categoría
class CategoryDeleteRequested extends CategoryEvent {
  final int id;
  const CategoryDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
