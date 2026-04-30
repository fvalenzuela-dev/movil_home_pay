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

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      // Login
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(
          publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY'] ?? '',
        ),
      ),

      // Home with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Cuentas
          GoRoute(
            path: '/cuentas',
            name: 'cuentas',
            builder: (context, state) {
              final periodo = state.uri.queryParameters['periodo'] ?? '202404';
              return ListaCuentasPage(periodo: periodo);
            },
            routes: [
              GoRoute(
                path: 'detalle/:id',
                name: 'cuenta-detalle',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  final periodo = state.uri.queryParameters['periodo'] ?? '202404';
                  return CuentaDetallePage(cuentaId: id, periodo: periodo);
                },
              ),
            ],
          ),

          // Empresas
          GoRoute(
            path: '/empresas',
            name: 'empresas',
            builder: (context, state) => const ListaEmpresasPage(),
            routes: [
              GoRoute(
                path: 'nueva',
                name: 'empresa-nueva',
                builder: (context, state) => const EmpresaFormPage(),
              ),
              GoRoute(
                path: 'editar/:id',
                name: 'empresa-editar',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return EmpresaFormPage(empresaId: id);
                },
              ),
            ],
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
}

/// Main shell with bottom navigation
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
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
