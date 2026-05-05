import '../entities/cuenta.dart';

/// Cuenta repository interface
abstract class CuentaRepository {
  /// Get list of accounts for a specific period (yyyymm format)
  Future<List<Cuenta>> getCuentasPorPeriodo(String periodo);

  Future<Cuenta> getDetalleCuenta(String accountId, String cuentaId);

  Future<bool> registrarPago(
    String cuentaId,
    String accountId,
    double montoTotal,
    double montoPagado,
  );

  /// Reabre una cuenta pagada, reseteando el estado a no pagada
  /// [cuentaId] - ID del billing
  /// [accountId] - ID de la cuenta
  /// [montoOriginal] - El monto facturado original (amount_billed) que se preserva
  Future<bool> reopenAccount(String cuentaId, String accountId, double montoOriginal);
}
