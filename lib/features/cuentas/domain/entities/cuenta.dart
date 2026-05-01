import 'package:equatable/equatable.dart';

/// Representa un AccountBilling de la API
class Cuenta extends Equatable {
  final String id;
  final String accountId;
  final String nombre;
  final double monto;
  final double montoPagado;
  final String estado; // 'pagada' | 'pendiente' | 'vencida'
  final DateTime? fechaPago;
  final String periodo; // YYYYMM como string

  const Cuenta({
    required this.id,
    required this.accountId,
    required this.nombre,
    required this.monto,
    required this.montoPagado,
    required this.estado,
    this.fechaPago,
    required this.periodo,
  });

  bool get isPaid => estado == 'pagada';
  double get saldo => monto - montoPagado;

  @override
  List<Object?> get props =>
      [id, accountId, nombre, monto, montoPagado, estado, fechaPago, periodo];
}
