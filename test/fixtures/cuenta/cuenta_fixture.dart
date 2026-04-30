import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';

/// Cuenta test fixture factory
class CuentaFixture {
  /// Creates a valid cuenta with all fields populated
  static Cuenta createValidCuenta({
    String? id,
    String? accountId,
    String? nombre,
    double? monto,
    double? montoPagado,
    String? estado,
    DateTime? fechaPago,
    String? periodo,
  }) {
    return Cuenta(
      id: id ?? 'cta_001',
      accountId: accountId ?? 'acc_123',
      nombre: nombre ?? 'Netflix',
      monto: monto ?? 14990.0,
      montoPagado: montoPagado ?? 0.0,
      estado: estado ?? 'pendiente',
      fechaPago: fechaPago,
      periodo: periodo ?? '202404',
    );
  }

  /// Creates a paid cuenta
  static Cuenta createPaidCuenta() {
    return Cuenta(
      id: 'cta_paid',
      accountId: 'acc_123',
      nombre: 'Spotify',
      monto: 5990.0,
      montoPagado: 5990.0,
      estado: 'pagada',
      fechaPago: DateTime(2024, 4, 15),
      periodo: '202404',
    );
  }

  /// Creates an overdue cuenta
  static Cuenta createOverdueCuenta() {
    return Cuenta(
      id: 'cta_overdue',
      accountId: 'acc_456',
      nombre: 'Enel',
      monto: 45000.0,
      montoPagado: 0.0,
      estado: 'vencida',
      periodo: '202403',
    );
  }

  /// Creates a cuenta with partial payment
  static Cuenta createPartialPaymentCuenta() {
    return Cuenta(
      id: 'cta_partial',
      accountId: 'acc_789',
      nombre: 'Gas',
      monto: 25000.0,
      montoPagado: 10000.0,
      estado: 'pendiente',
      periodo: '202404',
    );
  }

  /// Creates a cuenta without fechaPago
  static Cuenta createCuentaWithoutFechaPago() {
    return Cuenta(
      id: 'cta_no_fecha',
      accountId: 'acc_123',
      nombre: 'Internet',
      monto: 29990.0,
      montoPagado: 0.0,
      estado: 'pendiente',
      periodo: '202404',
    );
  }

  /// Creates cuenta JSON map for datasource parsing tests
  static Map<String, dynamic> createCuentaJson({
    String? id,
    String? accountId,
    String? nombre,
    double? monto,
    double? montoPagado,
    String? estado,
    String? fechaPago,
    String? periodo,
  }) {
    return {
      'id': id ?? 'cta_json',
      'account_id': accountId ?? 'acc_123',
      'nombre': nombre ?? 'Test Company',
      'monto': monto ?? 10000.0,
      'monto_pagado': montoPagado ?? 0.0,
      'estado': estado ?? 'pendiente',
      if (fechaPago != null) 'fecha_pago': fechaPago,
      'periodo': periodo ?? '202404',
    };
  }

  /// Creates a list of cuentas for list tests
  static List<Cuenta> createCuentaList({int count = 3}) {
    return List.generate(count, (index) {
      return Cuenta(
        id: 'cta_$index',
        accountId: 'acc_$index',
        nombre: 'Service $index',
        monto: (index + 1) * 10000.0,
        montoPagado: index == 0 ? (index + 1) * 10000.0 : 0.0,
        estado: index == 0 ? 'pagada' : 'pendiente',
        periodo: '202404',
      );
    });
  }

  /// Creates cuentas for the same period (testing filtering)
  static List<Cuenta> createCuentasMismoPeriodo() {
    return [
      createValidCuenta(
        id: 'cta_1',
        nombre: 'Netflix',
        monto: 14990.0,
        montoPagado: 0.0,
        estado: 'pendiente',
        periodo: '202404',
      ),
      createPaidCuenta().copyWith(id: 'cta_2', periodo: '202404'),
      createPartialPaymentCuenta().copyWith(id: 'cta_3', periodo: '202404'),
    ];
  }

  /// Creates cuenta with specific ID for lookup tests
  static Cuenta createCuentaWithId(String id) {
    return Cuenta(
      id: id,
      accountId: 'acc_lookup',
      nombre: 'Lookup Company',
      monto: 9999.0,
      montoPagado: 0.0,
      estado: 'pendiente',
      periodo: '202404',
    );
  }
}

/// Extension to help with cuenta tests
extension CuentaExtension on Cuenta {
  /// Returns a copy with modified fields
  Cuenta copyWith({
    String? id,
    String? accountId,
    String? nombre,
    double? monto,
    double? montoPagado,
    String? estado,
    DateTime? fechaPago,
    String? periodo,
  }) {
    return Cuenta(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      nombre: nombre ?? this.nombre,
      monto: monto ?? this.monto,
      montoPagado: montoPagado ?? this.montoPagado,
      estado: estado ?? this.estado,
      fechaPago: fechaPago ?? this.fechaPago,
      periodo: periodo ?? this.periodo,
    );
  }
}