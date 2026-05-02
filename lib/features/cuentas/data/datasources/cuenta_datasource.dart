import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../domain/entities/cuenta.dart';

/// Datasource que consume la API de billings
class CuentaDatasource {
  final Dio _dio;

  CuentaDatasource(this._dio);

  /// Valida que el periodo tenga formato YYYYMM
  static void _validarPeriodo(String periodo) {
    if (periodo.length != 6) {
      throw ArgumentError('Periodo debe tener formato YYYYMM');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(periodo)) {
      throw ArgumentError('Periodo debe contener solo dígitos');
    }
    final anio = int.tryParse(periodo.substring(0, 4));
    final mes = int.tryParse(periodo.substring(4, 6));
    if (anio == null ||
        mes == null ||
        anio < 2020 ||
        anio > 2100 ||
        mes < 1 ||
        mes > 12) {
      throw ArgumentError('Periodo inválido');
    }
  }

  /// Sanitiza IDs para prevenir injection
  static String _sanitizarId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('ID no puede estar vacío');
    }
    // Solo permite caracteres alfanuméricos, guiones y guiones bajos
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id)) {
      throw ArgumentError('ID contiene caracteres inválidos');
    }
    return id;
  }

  /// GET /periods/{period}/billings
  Future<List<Cuenta>> getCuentasPorPeriodo(String periodo) async {
    _validarPeriodo(periodo);

    final response = await _dio.get(
      ApiConfig.periodBillingsUrl(periodo),
      queryParameters: {'status': 'all', 'page': 1, 'page_size': 100},
    );

    final data = response.data;
    final List<dynamic> items =
        data['data'] ?? data['billings'] ?? data['items'] ?? [];
    return items.map((json) => _fromJson(json)).toList();
  }

  /// GET /periods/{period}/billings — filtra por id
  Future<Cuenta> getDetalle(String id, String periodo) async {
    _validarPeriodo(periodo);
    _sanitizarId(id);

    final cuentas = await getCuentasPorPeriodo(periodo);
    return cuentas.firstWhere(
      (c) => c.id == id,
      orElse: () => throw StateError('No se encontró la cuenta con id: $id'),
    );
  }

  /// PUT /accounts/{accountID}/billings/{id}
  Future<bool> registrarPago(
    String cuentaId,
    String accountId,
    double montoTotal,
    double montoPagado,
  ) async {
    _sanitizarId(cuentaId);
    _sanitizarId(accountId);

    if (montoTotal < 0 || montoPagado < 0) {
      throw ArgumentError('Los montos no pueden ser negativos');
    }

    final response = await _dio.put(
      '${ApiConfig.baseUrl}/accounts/$accountId/billings/$cuentaId',
      data: {'amount_billed': montoTotal, 'amount_paid': montoPagado},
    );
    final billing = response.data['billing'] ?? response.data;
    return billing['is_paid'] == true;
  }

  Cuenta _fromJson(Map<String, dynamic> json) {
    // La API puede devolver: is_paid (bool), status (string: 'paid', 'pending', 'overdue')
    final isPaid = json['is_paid'] as bool? ?? false;
    final status = json['status'].toString().toLowerCase();
    
    // Determinar el estado correctamente
    String estado;
    if (isPaid || status == 'paid') {
      estado = 'pagada';
    } else if (status == 'overdue' || status == 'vencida') {
      estado = 'vencida';
    } else {
      estado = 'pendiente';
    }
    
    return Cuenta(
      id: json['id'] ?? '',
      accountId: json['account_id'] ?? '',
      nombre: json['account_name'] ?? json['name'] ?? json['account_id'] ?? '',
      monto: (json['amount_billed'] ?? 0).toDouble(),
      montoPagado: (json['amount_paid'] ?? 0).toDouble(),
      estado: estado,
      fechaPago: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'])
          : null,
      periodo: json['period']?.toString() ?? '',
    );
  }
}
