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

  /// Extrae la lista de billings de una respuesta que puede venir envuelta
  /// en distintos niveles: [...], {billings: [...]}, {data: {billings: [...]}}.
  static List<dynamic> _extraerBillings(dynamic body) {
    dynamic node = body;
    // Desenvuelve hasta 3 niveles de Map buscando la lista bajo claves conocidas.
    for (var i = 0; i < 3 && node is Map; i++) {
      node = node['billings'] ?? node['data'] ?? node['items'] ?? node['results'];
    }
    if (node is List) return node;
    if (node is Map<String, dynamic>) return [node]; // respuesta de un solo objeto
    return const [];
  }

  /// POST /periods/{period}/open — abre todas las cuentas del periodo
  Future<List<Cuenta>> abrirPeriodo(String periodo) async {
    _validarPeriodo(periodo);

    final response = await _dio.post(ApiConfig.periodOpenUrl(periodo));

    final items = _extraerBillings(response.data);
    return items
        .map((json) => _fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /billings/{billingId} — direct endpoint
  Future<Cuenta> getDetalle(String cuentaId) async {
    _sanitizarId(cuentaId);

    final response = await _dio.get(
      ApiConfig.billingUrl(cuentaId),
    );
    final data = response.data;
    final billing = data['billing'] ?? data['data'] ?? data;
    return _fromJson(billing);
  }

  /// PUT /billings/{id} — registra un pago
  Future<bool> registrarPago(
    String cuentaId,
    double montoTotal,
    double montoPagado,
  ) async {
    _sanitizarId(cuentaId);

    if (montoTotal < 0 || montoPagado < 0) {
      throw ArgumentError('Los montos no pueden ser negativos');
    }

    final isPaid = montoPagado >= montoTotal;
    final response = await _dio.put(
      ApiConfig.billingUrl(cuentaId),
      data: {
        'amount_billed': montoTotal,
        'amount_paid': montoPagado,
        'is_paid': isPaid,
        if (isPaid) 'paid_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
    final billing = response.data['billing'] ?? response.data;
    return billing['is_paid'] == true;
  }

  /// PUT /billings/{id} — reabre una cuenta pagada
  /// Resetea amount_paid a 0 y is_paid a false para marcar como no pagada
  Future<bool> reopenAccount(String cuentaId, double montoOriginal) async {
    _sanitizarId(cuentaId);

    if (montoOriginal < 0) {
      throw ArgumentError('El monto no puede ser negativo');
    }

    final response = await _dio.put(
      ApiConfig.billingUrl(cuentaId),
      data: {
        'amount_billed': montoOriginal,
        'amount_paid': 0,
        'is_paid': false,
        'paid_at': null,
      },
    );
    final billing = response.data['billing'] ?? response.data;
    // Verificar que la cuenta quedó como no pagada
    return billing['is_paid'] != true && (billing['amount_paid'] ?? 0) == 0;
  }

  /// POST /accounts/{accountId}/billings — crea un billing individual para una cuenta
  Future<Cuenta> agregarCuentaIndividual({
    required String accountId,
    required double monto,
    double montoPagado = 0,
    String? periodo,
    String? nombre,
  }) async {
    _sanitizarId(accountId);

    if (monto < 0) {
      throw ArgumentError('El monto no puede ser negativo');
    }

    final body = <String, dynamic>{
      'amount_billed': monto,
      'amount_paid': montoPagado,
    };
    if (periodo != null && periodo.isNotEmpty) {
      body['period'] = periodo;
    }
    if (nombre != null && nombre.isNotEmpty) {
      body['account_name'] = nombre;
    }

    final response = await _dio.post(
      '${ApiConfig.baseUrl}/accounts/$accountId/billings',
      data: body,
    );

    final data = response.data;
    final billing = data['billing'] ?? data['data'] ?? data;
    return _fromJson(billing);
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
      nombre: json['account_name'] ?? json['name'] ?? '',
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
