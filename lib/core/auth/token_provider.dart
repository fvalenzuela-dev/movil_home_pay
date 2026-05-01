import 'package:flutter/foundation.dart';

/// Proveedor del JWT de Clerk para usarlo en los interceptores de Dio.
/// Se configura una vez luego del login y se usa en cada request.
class TokenProvider {
  TokenProvider._();

  /// Función que obtiene el token fresco desde Clerk
  static Future<String?> Function()? _getter;

  /// Configura el getter para obtener el token dinámicamente desde Clerk
  /// Esta función debe retornar el JWT fresco cada vez que se llame
  static void setGetter(Future<String?> Function() getter) {
    _getter = getter;
  }

  /// Obtiene el token fresco - llama al getter cada vez
  /// Esto asegura que el token no esté cacheado y sea siempre reciente
  static Future<String?> getToken() async {
    if (_getter != null) {
      try {
        return await _getter!.call();
      } catch (e) {
        debugPrint('[TokenProvider] Error getting token: $e');
        return null;
      }
    }
    debugPrint('[TokenProvider] No getter configured');
    return null;
  }

  /// Limpia el token (logout)
  static void clearToken() {
    _getter = null;
  }
}
