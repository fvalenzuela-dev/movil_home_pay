import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/token_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/cuentas_bloc.dart';

/// Lista de cuentas page - Stitch Design
class ListaCuentasPage extends StatefulWidget {
  final String periodo;

  const ListaCuentasPage({super.key, required this.periodo});

  @override
  State<ListaCuentasPage> createState() => _ListaCuentasPageState();
}

class _ListaCuentasPageState extends State<ListaCuentasPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'all';
  late String _currentPeriodo;

  @override
  void initState() {
    super.initState();
    _currentPeriodo = widget.periodo;
    context.read<CuentasBloc>().add(CuentasLoadRequested(_currentPeriodo));
  }

  List<String> _getAvailablePeriodos() {
    final now = DateTime.now();
    final periodos = <String>[];
    // Generar últimos 12 períodos
    for (int i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final periodo = '${date.year}${date.month.toString().padLeft(2, '0')}';
      periodos.add(periodo);
    }
    return periodos;
  }

  String _formatPeriodo(String periodo) {
    if (periodo.length != 6) return periodo;
    final mes = int.tryParse(periodo.substring(4, 6)) ?? 1;
    final anio = periodo.substring(0, 4);
    final meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${meses[mes - 1]} $anio';
  }

  void _onPeriodoChanged(String? periodo) {
    if (periodo != null && periodo != _currentPeriodo) {
      setState(() {
        _currentPeriodo = periodo;
      });
      context.read<CuentasBloc>().add(CuentasLoadRequested(periodo));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      backgroundColor: AppTheme.surfaceContainerLowest,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            // Monthly Summary Card
            SliverToBoxAdapter(
              child: _buildSummaryCard(),
            ),
            // Filters
            SliverToBoxAdapter(
              child: _buildFilters(),
            ),
            // Bills List
            _buildBillsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(Icons.menu),
                      color: AppTheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.outlineVariant),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.primarySeed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Home Pay',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primarySeed,
                      ),
                    ),
                  ],
                ),
          Row(
            children: [
              IconButton(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(Icons.logout),
                color: AppTheme.onSurfaceVariant,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: AppTheme.onSurfaceVariant,
              ),
            ],
          ),
            ],
          ),
          const SizedBox(height: 12),
          // Selector de período
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: DropdownButton<String>(
              value: _currentPeriodo,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _getAvailablePeriodos().map((periodo) {
                return DropdownMenuItem(
                  value: periodo,
                  child: Text(
                    _formatPeriodo(periodo),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _onPeriodoChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return BlocBuilder<CuentasBloc, CuentasState>(
      builder: (context, state) {
        double totalSpending = 0;
        double totalPendiente = 0;

        if (state is CuentasLoaded) {
          totalSpending = state.cuentas.fold(0, (sum, c) => sum + c.monto);
          totalPendiente = state.cuentas.fold(0, (sum, c) => sum + c.saldo);
        }

        final totalPagado = totalSpending - totalPendiente;
        final percentage = totalSpending > 0 ? (totalPagado / totalSpending * 100).clamp(0, 100) : 0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
          ),
child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total gastos del mes',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalSpending.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primarySeed,
                          letterSpacing: -0.02,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'pendiente por pagar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalPendiente.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                          letterSpacing: -0.02,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Budget Progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'pagado',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: AppTheme.surfaceDim,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage > 80 ? AppTheme.tertiaryColor : AppTheme.primarySeed,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${percentage.toInt()}% pagado',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.outline,
                          ),
                        ),
                        Text(
                          'de \$${totalSpending.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                  'Movil Home Pay',
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
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Empresas'),
            onTap: () {
              Navigator.pop(context);
              context.go('/empresas');
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

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterChip('Todas', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Pagadas', 'paid'),
            const SizedBox(width: 8),
            _buildFilterChip('Pendientes', 'pending'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppTheme.primarySeed,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primarySeed : AppTheme.outlineVariant,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildBillsList() {
    return BlocBuilder<CuentasBloc, CuentasState>(
      builder: (context, state) {
        if (state is CuentasLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CuentasLoaded) {
          final filteredCuentas = _filterCuentas(state.cuentas);

          if (filteredCuentas.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Sin cuentas para este período',
                  style: TextStyle(color: AppTheme.onSurfaceVariant),
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cuenta = filteredCuentas[index];
                  return _buildBillItem(cuenta);
                },
                childCount: filteredCuentas.length,
              ),
            ),
          );
        }

        if (state is CuentasError) {
          return SliverFillRemaining(
            child: Center(child: Text(state.message)),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  List<dynamic> _filterCuentas(List<dynamic> cuentas) {
    switch (_selectedFilter) {
      case 'paid':
        return cuentas.where((c) => c.estado == 'pagada').toList();
      case 'pending':
        return cuentas.where((c) => c.estado == 'pendiente' || c.estado == 'vencida').toList();
      default:
        return cuentas;
    }
  }

  Widget _buildBillItem(dynamic cuenta) {
    final isPaid = cuenta.estado == 'pagada';
    final isOverdue = cuenta.estado == 'vencida';
    final isPending = cuenta.estado == 'pendiente';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push('/cuentas/detalle/${cuenta.id}?accountId=${cuenta.accountId}&periodo=$_currentPeriodo'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(cuenta.nombre).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(cuenta.nombre),
                    color: _getCategoryColor(cuenta.nombre),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cuenta.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cuenta.periodo}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount & Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${cuenta.monto.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusBadge(isPaid, isOverdue, isPending),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isPaid, bool isOverdue, bool isPending) {
    Color backgroundColor;
    Color textColor;
    String label;

    if (isPaid) {
      backgroundColor = const Color(0xFFECFDF5); // emerald-50
      textColor = const Color(0xFF047857); // emerald-700
      label = 'PAGADA';
    } else if (isOverdue) {
      backgroundColor = const Color(0xFFFEF2F2); // red-50
      textColor = const Color(0xFFDC2626); // red-700
      label = 'VENCIDA';
    } else {
      backgroundColor = const Color(0xFFFEF3C7); // amber-50
      textColor = const Color(0xFFB45309); // amber-700
      label = 'PENDIENTE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('electricidad') || lower.contains('luz')) {
      return Icons.bolt;
    } else if (lower.contains('agua')) {
      return Icons.water_drop;
    } else if (lower.contains('internet') || lower.contains('wifi')) {
      return Icons.router;
    } else if (lower.contains('telefono') || lower.contains('movil')) {
      return Icons.smartphone;
    } else if (lower.contains('streaming') || lower.contains('netflix')) {
      return Icons.subscriptions;
    }
    return Icons.receipt_long;
  }

  Color _getCategoryColor(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('electricidad') || lower.contains('luz')) {
      return const Color(0xFFF59E0B); // orange
    } else if (lower.contains('agua')) {
      return AppTheme.primarySeed; // blue
    } else if (lower.contains('internet') || lower.contains('wifi')) {
      return const Color(0xFF6366F1); // indigo
    } else if (lower.contains('telefono') || lower.contains('movil')) {
      return const Color(0xFF8B5CF6); // purple
    } else if (lower.contains('streaming') || lower.contains('netflix')) {
      return const Color(0xFFEF4444); // red
    }
    return AppTheme.primarySeed;
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
              _logout();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    try {
      // Obtener el authState y cerrar sesión
      final authState = ClerkAuth.of(context, listen: false);
      await authState.signOut();
      
      // Limpiar el token
      TokenProvider.clearToken();
      
      if (mounted) {
        GoRouter.of(context).go('/login');
      }
    } catch (e) {
      debugPrint('Error en logout: $e');
      if (mounted) {
        GoRouter.of(context).go('/login');
      }
    }
  }
}
