import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/pages/categories_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cuentas/presentation/pages/cuenta_detalle_page.dart';
import '../../features/cuentas/presentation/pages/lista_cuentas_page.dart';
import '../../features/empresas/presentation/pages/empresa_form_page.dart';
import '../../features/empresas/presentation/pages/lista_empresas_page.dart';

/// App Router configuration using go_router
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      // Redirect root to cuentas
      if (state.uri.path == '/') {
        return '/cuentas';
      }
      return null;
    },
    routes: [
      // Login
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(
          publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY'] ?? '',
        ),
      ),

      // Shell route with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Cuentas - lista
          GoRoute(
            path: '/cuentas',
            name: 'cuentas',
            builder: (context, state) {
              final periodo = state.uri.queryParameters['periodo'] ?? _currentPeriodo();
              return ListaCuentasPage(periodo: periodo);
            },
          ),
          
          // Cuentas - detalle
          GoRoute(
            path: '/cuentas/detalle/:id',
            name: 'cuenta-detalle',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final periodo = state.uri.queryParameters['periodo'] ?? _currentPeriodo();
              return CuentaDetallePage(cuentaId: id, periodo: periodo);
            },
          ),

          // Empresas - lista
          GoRoute(
            path: '/empresas',
            name: 'empresas',
            builder: (context, state) => const ListaEmpresasPage(),
          ),
          
          // Empresas - nueva
          GoRoute(
            path: '/empresas/nueva',
            name: 'empresa-nueva',
            builder: (context, state) => const EmpresaFormPage(),
          ),
          
          // Empresas - editar
          GoRoute(
            path: '/empresas/editar/:id',
            name: 'empresa-editar',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EmpresaFormPage(empresaId: id);
            },
          ),

          // Categorías (Admin)
          GoRoute(
            path: '/categorias',
            name: 'categorias',
            builder: (context, state) => const CategoriesPage(),
          ),
        ],
      ),
    ],
  );

  static String _currentPeriodo() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}';
  }
}

/// Main shell with bottom navigation
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/cuentas')) return 0;
    if (location.startsWith('/empresas')) return 1;
    if (location.startsWith('/categorias')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('cuentas');
              break;
            case 1:
              context.goNamed('empresas');
              break;
            case 2:
              context.goNamed('categorias');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Cuentas',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Empresas',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categorías',
          ),
        ],
      ),
    );
  }
}
