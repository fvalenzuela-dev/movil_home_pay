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

  /// Abre todas las cuentas (billings) de un periodo en una sola operación
  /// [periodo] - Periodo en formato YYYYMM
  /// Retorna la lista de cuentas abiertas
  Future<List<Cuenta>> abrirPeriodo(String periodo);

  /// Agrega una cuenta individual (billing) para una cuenta específica
  /// [accountId] - ID de la cuenta
  /// [monto] - Monto facturado (amount_billed)
  /// [montoPagado] - Monto pagado (default: 0)
  /// [periodo] - Periodo opcional en formato YYYYMM (envía en body si se provee)
  /// [nombre] - Nombre opcional de la cuenta
  Future<Cuenta> agregarCuentaIndividual({
    required String accountId,
    required double monto,
    double montoPagado = 0,
    String? periodo,
    String? nombre,
  });
}
