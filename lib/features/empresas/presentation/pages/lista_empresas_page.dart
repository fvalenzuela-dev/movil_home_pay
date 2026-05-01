import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/empresa_bloc.dart';
import '../widgets/empresa_card.dart';

/// Lista de empresas page
class ListaEmpresasPage extends StatefulWidget {
  const ListaEmpresasPage({super.key});

  @override
  State<ListaEmpresasPage> createState() => _ListaEmpresasPageState();
}

class _ListaEmpresasPageState extends State<ListaEmpresasPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _isReloading = false;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEmpresas();
      _initialLoadDone = true;
    });
  }

  void _safeReload() {
    if (!_isReloading && _initialLoadDone) {
      _isReloading = true;
      _loadEmpresas();
      // Resetear el flag después de un delay
      Future.delayed(const Duration(seconds: 1), () {
        _isReloading = false;
      });
    }
  }

  void _loadEmpresas() {
    context.read<EmpresaBloc>().add(EmpresaListRequested(
          page: _currentPage,
          pageSize: _pageSize,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Empresas'),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      backgroundColor: AppTheme.surfaceContainerLowest,
      body: SafeArea(
        child: BlocConsumer<EmpresaBloc, EmpresaState>(
          listener: (context, state) {
            if (state is EmpresaOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              _loadEmpresas(); // Refresh list
            }
            if (state is EmpresaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EmpresaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmpresaListLoaded) {
              return _buildContent(state);
            }

            if (state is EmpresaError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error al cargar empresas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadEmpresas,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            // Initial state or stale state from detail view - load empresas
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _safeReload();
            });
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/empresas/nueva'),
        backgroundColor: AppTheme.primarySeed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(EmpresaListLoaded state) {
    if (state.empresas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: AppTheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay empresas registradas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca el botón + para agregar una empresa',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _buildHeader(state),
        ),
        // Companies List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final empresa = state.empresas[index];
                return EmpresaCard(
                  empresa: empresa,
                  onTap: () => context.push('/empresas/editar/${empresa.id}'),
                  onEdit: () => context.push('/empresas/editar/${empresa.id}'),
                  onDelete: () => _showDeleteConfirmation(context, empresa),
                );
              },
              childCount: state.empresas.length,
            ),
          ),
        ),
        // Pagination
        SliverToBoxAdapter(
          child: _buildPagination(state),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 80), // Space for FAB
        ),
      ],
    );
  }

  Widget _buildHeader(EmpresaListLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total: ${state.totalCount} empresas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (state.totalPages > 1)
                Text(
                  'Página ${state.page} de ${state.totalPages}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.outline,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(EmpresaListLoaded state) {
    if (state.totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: state.page > 1
                ? () {
                    setState(() {
                      _currentPage = state.page - 1;
                    });
                    _loadEmpresas();
                  }
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          Text(
            'Página ${state.page}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: state.page < state.totalPages
                ? () {
                    setState(() {
                      _currentPage = state.page + 1;
                    });
                    _loadEmpresas();
                  }
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  'Home Pay',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              context.go('/cuentas');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Empresas'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () {
              Navigator.pop(context);
              context.go('/categorias');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, empresa) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Empresa'),
        content: Text(
          '¿Estás seguro que quieres eliminar "${empresa.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<EmpresaBloc>().add(EmpresaDeleteRequested(empresa.id));
              _loadEmpresas(); // Refresh list
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}