import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/clerk_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cuentas/data/datasources/cuenta_datasource.dart';
import '../../features/cuentas/data/repositories/cuenta_repository_impl.dart';
import '../../features/cuentas/domain/repositories/cuenta_repository.dart';
import '../../features/cuentas/presentation/bloc/cuentas_bloc.dart';
import '../../features/empresas/data/datasources/empresa_datasource.dart';
import '../../features/empresas/data/repositories/empresa_repository_impl.dart';
import '../../features/empresas/domain/repositories/empresa_repository.dart';
import '../../features/empresas/presentation/bloc/empresa_bloc.dart';
import '../../features/admin/data/datasources/category_datasource.dart';
import '../../features/admin/data/repositories/category_repository_impl.dart';
import '../../features/admin/domain/repositories/category_repository.dart';
import '../../features/admin/presentation/bloc/category_bloc.dart';
import '../auth/token_provider.dart';
import '../config/api_config.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  _registerExternal();
  _registerDataSources();
  _registerRepositories();
  _registerBlocs();
}

void _registerExternal() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor que agrega el Bearer token de Clerk en cada request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenProvider.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // Retry interceptor para fallos de red y 401 (token expirado)
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final options = error.requestOptions;

          // Reintentar en errores 401 (token expirado) - obtener nuevo token
          if (error.response?.statusCode == 401 &&
              options.extra['retryCount'] == null) {
            options.extra['retryCount'] = 1;

            debugPrint('[DIO] Token expirado, obteniendo nuevo token...');

            // Obtener nuevo token
            final newToken = await TokenProvider.getToken();
            if (newToken != null) {
              options.headers['Authorization'] = 'Bearer $newToken';

              try {
                final response = await dio.fetch(options);
                debugPrint('[DIO] Token renovado, request exitosa');
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }

          // Solo reintentar en errores de conexión/tiempo de espera
          if (_esErrorReintentable(error) &&
              options.extra['retryCount'] == null) {
            options.extra['retryCount'] = 1;

            // Esperar 1 segundo antes de reintentar
            await Future.delayed(const Duration(seconds: 1));

            try {
              final response = await dio.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Solo loguear en debug - nunca en producción
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );

    return dio;
  });
}

/// Verifica si el error es reintentable
bool _esErrorReintentable(DioException error) {
  return error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError;
}

void _registerDataSources() {
  // Auth data source
  getIt.registerLazySingleton<ClerkDatasource>(() => ClerkDatasource());

  // Cuenta data source
  getIt.registerLazySingleton<CuentaDatasource>(
    () => CuentaDatasource(getIt<Dio>()),
  );

  // Category data source
  getIt.registerLazySingleton<CategoryDatasource>(
    () => CategoryDatasource(getIt<Dio>()),
  );

  // Empresa data source
  getIt.registerLazySingleton<EmpresaDatasource>(
    () => EmpresaDatasource(getIt<Dio>()),
  );
}

void _registerRepositories() {
  // Auth repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ClerkDatasource>()),
  );

  // Cuenta repository
  getIt.registerLazySingleton<CuentaRepository>(
    () => CuentaRepositoryImpl(getIt<CuentaDatasource>()),
  );

  // Category repository
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<CategoryDatasource>()),
  );

  // Empresa repository
  getIt.registerLazySingleton<EmpresaRepository>(
    () => EmpresaRepositoryImpl(getIt<EmpresaDatasource>()),
  );
}

void _registerBlocs() {
  // Auth BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(),
  );

  // Cuentas BLoC
  getIt.registerFactory<CuentasBloc>(
    () => CuentasBloc(getIt<CuentaRepository>()),
  );

  // Category BLoC
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(getIt<CategoryRepository>()),
  );

  // Empresa BLoC
  getIt.registerFactory<EmpresaBloc>(
    () => EmpresaBloc(getIt<EmpresaRepository>()),
  );
}
