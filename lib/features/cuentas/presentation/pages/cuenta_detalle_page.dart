import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/cuenta.dart';
import '../bloc/cuentas_bloc.dart';
import '../widgets/estado_badge.dart';

/// Detalle de un billing
class CuentaDetallePage extends StatefulWidget {
  final String cuentaId;
  final String accountId;
  final String periodo;

  const CuentaDetallePage({
    super.key,
    required this.cuentaId,
    required this.accountId,
    required this.periodo,
  });

  @override
  State<CuentaDetallePage> createState() => _CuentaDetallePageState();
}

class _CuentaDetallePageState extends State<CuentaDetallePage> {
  final _montoController = TextEditingController();
  final _montoTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CuentasBloc>().add(
      CuentaDetalleRequested(widget.cuentaId, widget.accountId, widget.periodo),
    );
  }

  @override
  void dispose() {
    _montoController.dispose();
    _montoTotalController.dispose();
    super.dispose();
  }

  void _precargarCampos(Cuenta cuenta) {
    if (_montoTotalController.text.isEmpty) {
      _montoTotalController.text = cuenta.monto.toStringAsFixed(0);
    }
    if (_montoController.text.isEmpty) {
      _montoController.text = cuenta.montoPagado.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<CuentasBloc>().add(CuentasLoadRequested(widget.periodo));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: BlocConsumer<CuentasBloc, CuentasState>(
          listener: (context, state) {
            if (state is PagoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pago registrado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<CuentasBloc>().add(
                CuentasLoadRequested(widget.periodo),
              );
              context.go('/cuentas?periodo=${widget.periodo}');
            } else if (state is PagoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ReopenSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cuenta reabierta exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<CuentasBloc>().add(
                CuentaDetalleRequested(widget.cuentaId, widget.accountId, widget.periodo),
              );
            } else if (state is ReopenFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CuentasLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CuentaDetalleLoaded) {
              _precargarCampos(state.cuenta);
              return _buildContent(context, state.cuenta, theme);
            }
            if (state is CuentasError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Cuenta cuenta, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIcon(cuenta.nombre),
                          size: 28,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          cuenta.nombreDisplay,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      EstadoBadge(estado: cuenta.estado),
                    ],
                  ),
                  const Divider(height: 32),
                  _infoRow(
                    'Total facturado',
                    '\$${cuenta.monto.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    'Total pagado',
                    '\$${cuenta.montoPagado.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    'Saldo pendiente',
                    '\$${cuenta.saldo.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Período', cuenta.periodo),
                  if (cuenta.fechaPago != null) ...[
                    const SizedBox(height: 8),
                    _infoRow('Pagado el', formatYmd(cuenta.fechaPago!)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!cuenta.isPaid) ...[
            Text('Registrar', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _montoTotalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Total facturado',
                        prefixText: '\$ ',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _montoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Monto pagado',
                        prefixText: '\$ ',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _registrarPago(context, cuenta),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primarySeed,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Esta cuenta ya está pagada',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => _showReopenConfirmation(context, cuenta),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reabrir cuenta'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange.shade700,
                          side: BorderSide(color: Colors.orange.shade700),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _registrarPago(BuildContext context, Cuenta cuenta) {
    final montoTotalText = _montoTotalController.text.trim();
    final montoPagadoText = _montoController.text.trim();

    final montoTotal = montoTotalText.isNotEmpty
        ? double.tryParse(montoTotalText)
        : null;
    if (montoTotalText.isNotEmpty && montoTotal == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Total facturado inválido')));
      return;
    }

    if (montoPagadoText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese el monto pagado')));
      return;
    }
    final montoPagado = double.tryParse(montoPagadoText);
    if (montoPagado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Monto pagado inválido')));
      return;
    }

    context.read<CuentasBloc>().add(
      PagoRegistrado(
        cuenta.id,
        cuenta.accountId,
        montoTotal ?? cuenta.monto,
        montoPagado,
      ),
    );
  }

  IconData _getIcon(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('luz') || lower.contains('electricidad')) {
      return Icons.bolt;
    }
    if (lower.contains('agua')) {
      return Icons.water_drop;
    }
    if (lower.contains('internet') || lower.contains('wifi')) {
      return Icons.wifi;
    }
    if (lower.contains('gas')) {
      return Icons.local_fire_department;
    }
    if (lower.contains('telefono') || lower.contains('celular')) {
      return Icons.phone_android;
    }
    return Icons.receipt_long;
  }

  Future<void> _showReopenConfirmation(BuildContext context, Cuenta cuenta) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reabrir cuenta'),
        content: const Text(
          '¿Estás seguro de que deseas reabrir esta cuenta pagada?\n\n'
          'El monto pagado se eliminará y la cuenta volverá a estado pendiente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reabrir'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      _handleReopen(context, cuenta);
    }
  }

  void _handleReopen(BuildContext context, Cuenta cuenta) {
    context.read<CuentasBloc>().add(
      CuentaReopenRequested(
        cuentaId: cuenta.id,
        accountId: cuenta.accountId,
        montoOriginal: cuenta.monto,
      ),
    );
  }
}
