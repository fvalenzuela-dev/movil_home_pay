import 'package:flutter/material.dart';

import '../../domain/entities/cuenta.dart';
import 'estado_badge.dart';

/// Cuenta card widget
class CuentaCard extends StatelessWidget {
  final Cuenta cuenta;
  final VoidCallback? onTap;

  const CuentaCard({super.key, required this.cuenta, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(cuenta.nombre),
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cuenta.nombre, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '\$${cuenta.monto.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Status badge
              EstadoBadge(estado: cuenta.estado),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('luz') || lower.contains('electricidad')) {
      return Icons.bolt;
    } else if (lower.contains('agua')) {
      return Icons.water_drop;
    } else if (lower.contains('internet') || lower.contains('wifi')) {
      return Icons.wifi;
    } else if (lower.contains('gas')) {
      return Icons.local_fire_department;
    } else if (lower.contains('telefono') || lower.contains('celular')) {
      return Icons.phone_android;
    }
    return Icons.receipt_long;
  }
}
