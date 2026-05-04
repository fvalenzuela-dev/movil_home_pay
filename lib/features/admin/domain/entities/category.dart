import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movil_home_pay/core/theme/app_theme.dart';

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

/// Category color enum for platform-specific colors
enum CategoryColor {
  catPrimary,
  catSecondary,
  catError,
  catSuccess,
  catWarning,
  catTertiary,
}

/// Extension for CategoryColor to provide color values and API name mapping
extension CategoryColorExtension on CategoryColor {
  /// Returns the AppTheme color for this category color
  Color get colorValue {
    switch (this) {
      case CategoryColor.catPrimary:
        return AppTheme.primarySeed;
      case CategoryColor.catSecondary:
        return AppTheme.secondarySeed;
      case CategoryColor.catError:
        return AppTheme.errorColor;
      case CategoryColor.catSuccess:
        return AppTheme.successColor;
      case CategoryColor.catWarning:
        return AppTheme.warningColor;
      case CategoryColor.catTertiary:
        return AppTheme.tertiaryColor;
    }
  }

  /// Returns the API name string for this category color
  String get apiName {
    switch (this) {
      case CategoryColor.catPrimary:
        return 'primary';
      case CategoryColor.catSecondary:
        return 'secondary';
      case CategoryColor.catError:
        return 'error';
      case CategoryColor.catSuccess:
        return 'success';
      case CategoryColor.catWarning:
        return 'warning';
      case CategoryColor.catTertiary:
        return 'tertiary';
    }
  }

  /// Creates a CategoryColor from an API name string
  static CategoryColor? fromApiName(String? apiName) {
    if (apiName == null || apiName.isEmpty) {
      return null;
    }

    final lowerName = apiName.toLowerCase();
    for (final color in CategoryColor.values) {
      if (color.apiName == lowerName) {
        return color;
      }
    }
    return null;
  }
}

/// Representa una Category de la API
class Category extends Equatable {
  final int id;
  final String name;
  final String? iconApk;
  final String? iconWeb;
  final String? colorApk;
  final String? colorWeb;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.iconApk,
    this.iconWeb,
    this.colorApk,
    this.colorWeb,
    this.createdAt,
    this.updatedAt,
  });

  /// Returns the IconData for this category based on iconApk
  IconData get icon => CategoryIcons.getIcon(iconApk);

  /// Returns the Color for this category based on colorApk
  Color? get categoryColor {
    final colorEnum = CategoryColorExtension.fromApiName(colorApk);
    return colorEnum?.colorValue;
  }

  Category copyWith({
    int? id,
    String? name,
    String? iconApk,
    String? iconWeb,
    String? colorApk,
    String? colorWeb,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconApk: iconApk ?? this.iconApk,
      iconWeb: iconWeb ?? this.iconWeb,
      colorApk: colorApk ?? this.colorApk,
      colorWeb: colorWeb ?? this.colorWeb,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        iconApk,
        iconWeb,
        colorApk,
        colorWeb,
        createdAt,
        updatedAt,
      ];
}