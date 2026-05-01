import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Mapeo de nombres de iconos a IconData
class CategoryIcons {
  static const Map<String, IconData> icons = {
    'streaming': Icons.play_circle_outline,
    'netflix': Icons.movie,
    'spotify': Icons.music_note,
    'agua': Icons.water_drop,
    'luz': Icons.bolt,
    'gas': Icons.local_fire_department,
    'internet': Icons.wifi,
    'telefono': Icons.phone,
    'celular': Icons.smartphone,
    'seguro': Icons.security,
    'mantenimiento': Icons.build,
    'arriendo': Icons.home,
    'credito': Icons.credit_card,
    'deuda': Icons.account_balance,
    'salud': Icons.health_and_safety,
    'medico': Icons.medical_services,
    'farmacia': Icons.local_pharmacy,
    'gym': Icons.fitness_center,
    'educacion': Icons.school,
    'transporte': Icons.directions_car,
    'combustible': Icons.local_gas_station,
    'peaje': Icons.toll,
    'estacionamiento': Icons.local_parking,
    'supermercado': Icons.shopping_cart,
    'restaurante': Icons.restaurant,
    'tienda': Icons.store,
    'mascota': Icons.pets,
    'regalo': Icons.card_giftcard,
    'otro': Icons.more_horiz,
  };

  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return Icons.category;
    }
    return icons[iconName.toLowerCase()] ?? Icons.category;
  }

  static List<String> get iconNames => icons.keys.toList();
}

/// Representa una Category de la API
class Category extends Equatable {
  final int id;
  final String name;
  final String? iconName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.iconName,
    this.createdAt,
    this.updatedAt,
  });

  IconData get icon => CategoryIcons.getIcon(iconName);

  Category copyWith({
    int? id,
    String? name,
    String? iconName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, iconName, createdAt, updatedAt];
}
