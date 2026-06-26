import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/cuentas_bloc.dart';

/// Page for adding a new individual account/billing
class AgregarCuentaPage extends StatefulWidget {
  final String periodo;

  const AgregarCuentaPage({super.key, required this.periodo});

  @override
  State<AgregarCuentaPage> createState() => _AgregarCuentaPageState();
}

class _AgregarCuentaPageState extends State<AgregarCuentaPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountIdController = TextEditingController();
  final _montoTotalController = TextEditingController();
  final _montoPagadoController = TextEditingController();
  final _nombreController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _accountIdController.dispose();
    _montoTotalController.dispose();
    _montoPagadoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  String? _validateAccountId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El ID de cuenta es obligatorio';
    }
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value)) {
      return 'ID contiene caracteres inválidos';
    }
    return null;
  }

  String? _validateMonto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El monto es obligatorio';
    }
    final monto = double.tryParse(value);
    if (monto == null) {
      return 'Ingrese un número válido';
    }
    if (monto < 0) {
      return 'El monto no puede ser negativo';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final accountId = _accountIdController.text.trim();
      final monto = double.parse(_montoTotalController.text.trim());
      final montoPagado = _montoPagadoController.text.trim().isNotEmpty
          ? double.parse(_montoPagadoController.text.trim())
          : 0.0;
      final nombre = _nombreController.text.trim();

      setState(() => _isLoading = true);

      context.read<CuentasBloc>().add(
        AgregarCuentaIndividualRequested(
          accountId: accountId,
          monto: monto,
          montoPagado: montoPagado,
          periodo: widget.periodo,
          nombre: nombre.isNotEmpty ? nombre : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppTheme.surfaceContainerLowest,
      ),
      backgroundColor: AppTheme.surfaceContainerLowest,
      body: BlocConsumer<CuentasBloc, CuentasState>(
        listener: (context, state) {
          if (state is CuentasLoaded) {
            // Account added successfully and list reloaded
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cuenta agregada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is CuentaAgregadaFailure) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Account ID field
                    TextFormField(
                      controller: _accountIdController,
                      decoration: const InputDecoration(
                        labelText: 'ID de Cuenta *',
                        hintText: 'Ej: spotify-netflix',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.tag),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: _validateAccountId,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Monto Total field
                    TextFormField(
                      controller: _montoTotalController,
                      decoration: const InputDecoration(
                        labelText: 'Monto Total *',
                        hintText: 'Ej: 15000',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: _validateMonto,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Monto Pagado field (optional)
                    TextFormField(
                      controller: _montoPagadoController,
                      decoration: const InputDecoration(
                        labelText: 'Monto Pagado',
                        hintText: 'Opcional - déjelo vacío si no ha pagado',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payment),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          return _validateMonto(value);
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Nombre field (optional)
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Cuenta',
                        hintText: 'Opcional - Ej: Netflix, Spotify',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 8),

                    // Periodo info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Período: ${widget.periodo} (se usará el período actual)',
                        style: TextStyle(
                          color: AppTheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primarySeed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Agregar Cuenta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Loading overlay
                    if (_isLoading && state is CuentasLoading)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Agregando cuenta...'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}