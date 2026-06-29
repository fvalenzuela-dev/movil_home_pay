import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/account_bloc.dart';
import '../widgets/account_card.dart';

/// Lista de cuentas (master accounts) page
class ListaAccountsPage extends StatefulWidget {
  const ListaAccountsPage({super.key});

  @override
  State<ListaAccountsPage> createState() => _ListaAccountsPageState();
}

class _ListaAccountsPageState extends State<ListaAccountsPage> {
  bool _isReloading = false;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccounts();
      _initialLoadDone = true;
    });
  }

  /// Re-requests the list when the shared AccountBloc holds a stale non-list
  /// state (e.g. AccountDetailLoaded after returning from the edit form).
  /// Guarded to avoid a rebuild loop.
  void _safeReload() {
    if (!_isReloading && _initialLoadDone) {
      _isReloading = true;
      _loadAccounts();
      Future.delayed(const Duration(seconds: 1), () {
        _isReloading = false;
      });
    }
  }

  void _loadAccounts() {
    context.read<AccountBloc>().add(const AccountListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      body: SafeArea(
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              _loadAccounts();
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
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AccountListLoaded) {
              return _buildContent(context, state);
            }

            if (state is AccountError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAccounts,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            // Initial or stale state (e.g. after returning from the edit
            // form) — re-request the list instead of hanging on a spinner.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _safeReload();
            });
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('account-nueva'),
        backgroundColor: AppTheme.primarySeed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AccountListLoaded state) {
    if (state.accounts.isEmpty) {
      return const Center(child: Text('No hay cuentas registradas'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AccountBloc>().add(const AccountListRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.accounts.length,
        itemBuilder: (context, index) {
          final account = state.accounts[index];
          return GestureDetector(
            onTap: () => context.pushNamed(
              'account-editar',
              pathParameters: {'id': account.id},
            ),
            child: AccountCard(
              account: account,
              onEdit: () => context.pushNamed(
                'account-editar',
                pathParameters: {'id': account.id},
              ),
              onDelete: () => _showDeleteConfirmation(context, account),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, account) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Cuenta'),
        content: Text(
          '¿Estás seguro que quieres eliminar "${account.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<AccountBloc>()
                  .add(AccountDeleteRequested(account.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
