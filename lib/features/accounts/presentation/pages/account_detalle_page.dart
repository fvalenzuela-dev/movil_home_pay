import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';

/// Read-only detail page for a master billing Account.
///
/// Dispatches [AccountDetailRequested] on init and renders [AccountDetailLoaded].
/// Provides an "Editar" action that navigates to the edit form.
class AccountDetallePage extends StatefulWidget {
  final String accountId;

  const AccountDetallePage({super.key, required this.accountId});

  @override
  State<AccountDetallePage> createState() => _AccountDetallePageState();
}

class _AccountDetallePageState extends State<AccountDetallePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<AccountBloc>()
            .add(AccountDetailRequested(widget.accountId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Cuenta'),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AccountDetailLoaded) {
            return _buildContent(context, state.account);
          }
          if (state is AccountError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Account account) {
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
                  _infoRow('Nombre', account.name),
                  _infoRow('Empresa', account.companyName ?? '-'),
                  if (account.accountNumber != null &&
                      account.accountNumber!.isNotEmpty)
                    _infoRow('Número de cuenta', account.accountNumber!),
                  _infoRow('Día de cobro', account.billingDay.toString()),
                  _infoRow(
                      'Auto acumular', account.autoAccumulate ? 'Sí' : 'No'),
                  _infoRow('Estado', account.isActive ? 'Activa' : 'Inactiva'),
                  if (account.createdAt != null)
                    _infoRow('Creada', account.createdAt!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
              onPressed: () => context.pushNamed(
                'account-editar',
                pathParameters: {'id': widget.accountId},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
