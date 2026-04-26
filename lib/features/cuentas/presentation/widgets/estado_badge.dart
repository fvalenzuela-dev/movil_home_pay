import 'package:flutter/material.dart';

/// Estado badge widget (pagada/pendiente)
class EstadoBadge extends StatelessWidget {
  final String estado;

  const EstadoBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final isPagada = estado == 'pagada';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPagada ? Colors.green.shade100 : Colors.amber.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPagada ? Icons.check_circle : Icons.pending,
            size: 16,
            color: isPagada ? Colors.green.shade700 : Colors.amber.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isPagada ? 'Pagada' : 'Pendiente',
            style: TextStyle(
              color: isPagada ? Colors.green.shade700 : Colors.amber.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
