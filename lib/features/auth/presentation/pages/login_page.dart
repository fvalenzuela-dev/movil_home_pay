import 'dart:async';
import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/token_provider.dart';
import '../../../../core/theme/app_theme.dart';

/// Login page - diseño propio con Clerk
class LoginPage extends StatefulWidget {
  final String publishableKey;

  const LoginPage({super.key, required this.publishableKey});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription? _tokenSubscription;
  bool _hasNavigated = false;
  bool _isLoading = false;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String _currentPeriodo() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setupTokenListener(ClerkAuthState authState) {
    TokenProvider.setGetter(() async {
      try {
        if (authState.session == null) {
          return null;
        }
        final token = await authState.sessionToken();
        return token.jwt;
      } catch (e) {
        return null;
      }
    });

    _tokenSubscription?.cancel();
    _tokenSubscription = authState.sessionTokenStream.listen((token) {
      // Token actualizado
    });
  }

  void _navigateToCuentas() {
    if (!_hasNavigated && mounted) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          GoRouter.of(context).go('/cuentas/${_currentPeriodo()}');
        }
      });
    }
  }

  Future<void> _handleSignIn(ClerkAuthState authState) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa email y contraseña')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Usar Clerk para hacer sign in
      await authState.attemptSignIn(
        strategy: clerk.Strategy.password,
        identifier: email,
        password: password,
      );
      
      // Si llegó hasta aquí, el login fue exitoso
      // Esperar un poco para que se establezca la sesión
      await Future.delayed(const Duration(milliseconds: 500));
      
      // El getter ya está configurado, solo navegar
      _navigateToCuentas();
    } catch (e) {
      debugPrint('Error en login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email o contraseña incorrectos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ClerkAuthBuilder(
          signedInBuilder: (context, authState) {
            _setupTokenListener(authState);
            _navigateToCuentas();
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Ingresando...'),
                ],
              ),
            );
          },
          signedOutBuilder: (context, authState) {
            _setupTokenListener(authState);
            return _buildLoginUI(authState);
          },
          builder: (context, authState) {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildLoginUI(ClerkAuthState authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          // Logo
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primarySeed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppTheme.primarySeed,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'HomePay',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primarySeed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Welcome
          const Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ingresá para continuar',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          // Email field
          const Text(
            'Correo electrónico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'tu@email.com',
              prefixIcon: const Icon(Icons.mail_outline, color: AppTheme.outline),
              filled: true,
              fillColor: AppTheme.surfaceContainerLowest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primarySeed, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Password field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primarySeed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSignIn(authState),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.outline,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              filled: true,
              fillColor: AppTheme.surfaceContainerLowest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primarySeed, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Sign In button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _handleSignIn(authState),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primarySeed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
