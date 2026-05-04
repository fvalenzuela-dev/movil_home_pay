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
  final String? iconApk;
  final String? colorApk;
  const CategoryCreateRequested(this.name, {this.iconApk, this.colorApk});

  @override
  List<Object?> get props => [name, iconApk, colorApk];
}

/// Actualizar una categoría existente
class CategoryUpdateRequested extends CategoryEvent {
  final int id;
  final String name;
  final String? iconApk;
  final String? colorApk;
  const CategoryUpdateRequested(this.id, this.name, {this.iconApk, this.colorApk});

  @override
  List<Object?> get props => [id, name, iconApk, colorApk];
}

/// Eliminar una categoría
class CategoryDeleteRequested extends CategoryEvent {
  final int id;
  const CategoryDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
