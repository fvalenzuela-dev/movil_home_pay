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
  Future<Cuenta> getDetalleCuenta(String id, String periodo) {
    return _datasource.getDetalle(id, periodo);
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
}
