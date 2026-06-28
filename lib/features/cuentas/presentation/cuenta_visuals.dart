import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

// Shared brand visuals for a cuenta, derived from its name. Single source of
// truth so the list, detail and card screens stay visually consistent.

/// Returns the category icon that represents the cuenta [nombre].
IconData cuentaIconFor(String nombre) {
  final lower = nombre.toLowerCase();
  if (lower.contains('electricidad') || lower.contains('luz')) {
    return Icons.bolt;
  } else if (lower.contains('agua')) {
    return Icons.water_drop;
  } else if (lower.contains('internet') || lower.contains('wifi')) {
    return Icons.router;
  } else if (lower.contains('telefono') || lower.contains('movil')) {
    return Icons.smartphone;
  } else if (lower.contains('streaming') || lower.contains('netflix')) {
    return Icons.subscriptions;
  }
  return Icons.receipt_long;
}

/// Returns the brand color that represents the cuenta [nombre].
Color cuentaColorFor(String nombre) {
  final lower = nombre.toLowerCase();
  if (lower.contains('electricidad') || lower.contains('luz')) {
    return const Color(0xFFF59E0B); // orange
  } else if (lower.contains('agua')) {
    return AppTheme.primarySeed; // blue
  } else if (lower.contains('internet') || lower.contains('wifi')) {
    return const Color(0xFF6366F1); // indigo
  } else if (lower.contains('telefono') || lower.contains('movil')) {
    return const Color(0xFF8B5CF6); // purple
  } else if (lower.contains('streaming') || lower.contains('netflix')) {
    return const Color(0xFFEF4444); // red
  }
  return AppTheme.primarySeed;
}
