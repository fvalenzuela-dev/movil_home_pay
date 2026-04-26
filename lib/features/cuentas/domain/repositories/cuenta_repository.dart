import '../entities/cuenta.dart';

/// Cuenta repository interface
abstract class CuentaRepository {
  /// Get list of accounts for a specific period (yyyymm format)
  Future<List<Cuenta>> getCuentasPorPeriodo(String periodo);

  Future<Cuenta> getDetalleCuenta(String id, String periodo);

  Future<bool> registrarPago(
    String cuentaId,
    String accountId,
    double montoTotal,
    double montoPagado,
  );
}
