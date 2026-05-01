import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/bloc/category_bloc.dart';
import 'features/admin/presentation/bloc/category_event.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cuentas/presentation/bloc/cuentas_bloc.dart';
import 'features/empresas/presentation/bloc/empresa_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize dependencies
  await initDependencies();

  runApp(MovilHomePayApp(
    clerkPublishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY'] ?? '',
  ));
}

class MovilHomePayApp extends StatelessWidget {
  final String clerkPublishableKey;

  const MovilHomePayApp({super.key, required this.clerkPublishableKey});

  @override
  Widget build(BuildContext context) {
    return ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: clerkPublishableKey,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
          ),
          BlocProvider<CuentasBloc>(
            create: (_) => getIt<CuentasBloc>(),
          ),
          BlocProvider<EmpresaBloc>(
            create: (_) => getIt<EmpresaBloc>(),
          ),
          BlocProvider<CategoryBloc>(
            create: (_) => getIt<CategoryBloc>()..add(CategoriesLoadRequested()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Movil Home Pay',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
