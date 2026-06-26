import '../../domain/entities/cuenta.dart';
import '../../domain/repositories/cuenta_repository.dart';
import '../datasources/cuenta_datasource.dart';

/// Cuenta repository implementation
class CuentaRepositoryImpl implements CuentaRepository {
  final CuentaDatasource _datasource;

  CuentaRepositoryImpl(this._datasource);

  @override
  Future<List<Cuenta>> getCuentasPorPeriodo(String periodo) {
    return _datasource.getCuentasPorPeriodo(periodo);
  }

  @override
  Future<Cuenta> getDetalleCuenta(String accountId, String cuentaId) {
    return _datasource.getDetalle(accountId, cuentaId);
  }

  @override
  Future<bool> registrarPago(
    String cuentaId,
    String accountId,
    double montoTotal,
    double montoPagado,
  ) {
    return _datasource.registrarPago(
      cuentaId,
      accountId,
      montoTotal,
      montoPagado,
    );
  }

  @override
  Future<bool> reopenAccount(
    String cuentaId,
    String accountId,
    double montoOriginal,
  ) {
    return _datasource.reopenAccount(cuentaId, accountId, montoOriginal);
  }

  @override
  Future<List<Cuenta>> abrirPeriodo(String periodo) {
    return _datasource.abrirPeriodo(periodo);
  }

  @override
  Future<Cuenta> agregarCuentaIndividual({
    required String accountId,
    required double monto,
    double montoPagado = 0,
    String? periodo,
    String? nombre,
  }) {
    return _datasource.agregarCuentaIndividual(
      accountId: accountId,
      monto: monto,
      montoPagado: montoPagado,
      periodo: periodo,
      nombre: nombre,
    );
  }
}
