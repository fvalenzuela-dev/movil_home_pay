import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/config/clerk_config.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/cuentas/domain/repositories/cuenta_repository.dart';
import 'features/cuentas/presentation/bloc/cuentas_bloc.dart';
import 'features/cuentas/presentation/pages/lista_cuentas_page.dart';
import 'features/cuentas/presentation/pages/cuenta_detalle_page.dart';
import 'features/admin/domain/repositories/category_repository.dart';
import 'features/admin/presentation/bloc/category_bloc.dart';
import 'features/admin/presentation/pages/categories_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initDependencies();
  runApp(const MovilHomePayApp());
}

/// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/login',
  // Para testing: quitar este redirect en producción
  // redirect: (context, state) => '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          LoginPage(publishableKey: ClerkConfig.publishableKey),
    ),
    GoRoute(
      path: '/cuentas',
      redirect: (context, state) => '/cuentas/${_getCurrentPeriodo()}',
    ),
    GoRoute(
      path: '/cuentas/:periodo',
      builder: (context, state) {
        final periodo = state.pathParameters['periodo'] ?? _getCurrentPeriodo();
        return ListaCuentasPage(periodo: periodo);
      },
    ),
    GoRoute(
      path: '/cuenta/:periodo/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final periodo = state.pathParameters['periodo']!;
        return CuentaDetallePage(cuentaId: id, periodo: periodo);
      },
    ),
    GoRoute(
      path: '/admin/categories',
      builder: (context, state) => const CategoriesPage(),
    ),
  ],
);

String _getCurrentPeriodo() {
  final now = DateTime.now();
  return '${now.year}${now.month.toString().padLeft(2, '0')}';
}

class MovilHomePayApp extends StatelessWidget {
  const MovilHomePayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return     MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => CuentasBloc(getIt<CuentaRepository>())),
        BlocProvider(create: (_) => CategoryBloc(getIt<CategoryRepository>())),
      ],
      child: ClerkAuth(
        config: ClerkAuthConfig(
          publishableKey: ClerkConfig.publishableKey,
          persistor: kIsWeb ? clerk.Persistor.none : null,
        ),
        child: MaterialApp.router(
          title: 'Movil Home Pay',
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
