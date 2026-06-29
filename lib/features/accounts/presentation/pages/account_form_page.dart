import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';
import '../../../empresas/domain/entities/empresa.dart';
import '../../../empresas/presentation/bloc/empresa_bloc.dart';

/// Form page for creating or editing an account.
/// NOTE: BlocProvider for EmpresaBloc is wired at ROUTE level in app_router.dart (ADR-2)
class AccountFormPage extends StatefulWidget {
  final String? accountId; // null = create mode, non-null = edit mode

  const AccountFormPage({super.key, this.accountId});

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _billingDayController = TextEditingController(text: '1');

  bool _isEditMode = false;
  Account? _existingAccount;

  /// Required FK — submit is disabled until set
  String? _companyId;
  bool _autoAccumulate = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.accountId != null;
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<AccountBloc>()
            .add(AccountDetailRequested(widget.accountId!));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _billingDayController.dispose();
    super.dispose();
  }

  void _populateForm(Account account) {
    _existingAccount = account;
    _nameController.text = account.name;
    _accountNumberController.text = account.accountNumber ?? '';
    _billingDayController.text = account.billingDay.toString();
    setState(() {
      _companyId = account.companyId;
      _autoAccumulate = account.autoAccumulate;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_companyId == null) return;

    final name = _nameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final billingDay = int.tryParse(_billingDayController.text.trim()) ?? 1;

    if (_isEditMode && _existingAccount != null) {
      final updated = _existingAccount!.copyWith(
        name: name,
        accountNumber: accountNumber.isEmpty ? null : accountNumber,
        billingDay: billingDay,
        autoAccumulate: _autoAccumulate,
        companyId: _companyId,
      );
      context.read<AccountBloc>().add(AccountUpdateRequested(updated));
    } else {
      final newAccount = Account(
        id: '',
        companyId: _companyId!,
        name: name,
        accountNumber: accountNumber.isEmpty ? null : accountNumber,
        billingDay: billingDay,
        autoAccumulate: _autoAccumulate,
      );
      context.read<AccountBloc>().add(AccountCreateRequested(newAccount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Cuenta' : 'Nueva Cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountDetailLoaded && _isEditMode) {
            _populateForm(state.account);
          }
          if (state is AccountOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          }
          if (state is AccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Empresa dropdown (form-scoped EmpresaBloc — provided at route level)
          BlocBuilder<EmpresaBloc, EmpresaState>(
            builder: (context, state) {
              final List<Empresa> empresas;
              if (state is EmpresaListLoaded) {
                empresas = state.empresas;
              } else {
                empresas = [];
              }

              // Use key to force rebuild when _companyId changes (edit mode population)
              return DropdownButtonFormField<String>(
                key: ValueKey(_companyId),
                initialValue: _companyId,
                decoration: const InputDecoration(
                  labelText: 'Empresa *',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seleccione una empresa'),
                isExpanded: true,
                items: empresas
                    .map((e) => DropdownMenuItem<String>(
                          value: e.id,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _companyId = value);
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Name field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre *',
              hintText: 'Nombre de la cuenta',
              prefixIcon: Icon(Icons.label),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Account number field (optional)
          TextFormField(
            controller: _accountNumberController,
            decoration: const InputDecoration(
              labelText: 'Número de cuenta (opcional)',
              prefixIcon: Icon(Icons.numbers),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Billing day
          TextFormField(
            controller: _billingDayController,
            decoration: const InputDecoration(
              labelText: 'Día de cobro *',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              final day = int.tryParse(value ?? '');
              if (day == null || day < 1 || day > 31) {
                return 'Ingrese un día entre 1 y 31';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Auto accumulate toggle
          SwitchListTile(
            title: const Text('Auto acumular'),
            value: _autoAccumulate,
            onChanged: (value) => setState(() => _autoAccumulate = value),
          ),
          const SizedBox(height: 24),

          // Submit button — disabled until companyId is set
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _companyId == null ? null : _submit,
              child: Text(_isEditMode ? 'Guardar Cambios' : 'Crear Cuenta'),
            ),
          ),
        ],
      ),
    );
  }
}
