import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/config/clerk_config.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/accounts/presentation/bloc/account_bloc.dart';
import 'features/admin/presentation/bloc/category_bloc.dart';
import 'features/admin/presentation/bloc/category_event.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cuentas/presentation/bloc/cuentas_bloc.dart';
import 'features/empresas/presentation/bloc/empresa_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // For local dev: ensure .env exists (copy from .env.example)
  // For CI/CD: .env is optional, falls back to defaults in config files
  await dotenv.load(fileName: '.env', isOptional: true);

  // Validate Clerk publishable key early - will throw with clear message if invalid
  final publishableKey = ClerkConfig.publishableKey;

  // Initialize dependencies
  await initDependencies();

  runApp(MovilHomePayApp(clerkPublishableKey: publishableKey));
}

class MovilHomePayApp extends StatelessWidget {
  final String clerkPublishableKey;

  const MovilHomePayApp({super.key, required this.clerkPublishableKey});

  @override
  Widget build(BuildContext context) {
    // Use no persistor to prevent automatic session restoration on startup.
    // Users must explicitly sign in each time the app starts.
    return ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: clerkPublishableKey,
        persistor: ClerkConfig.autoRestoreSession
            ? clerk.DefaultPersistor(getCacheDirectory: _getAppDocDir)
            : clerk.Persistor.none,  // Use explicit none instead of null
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
          BlocProvider<AccountBloc>(
            create: (_) => getIt<AccountBloc>(),
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

Future<Directory> _getAppDocDir() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir;
}
