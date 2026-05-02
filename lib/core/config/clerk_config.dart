import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clerk Authentication Configuration
class ClerkConfig {
  /// Clerk Publishable Key - try dotenv first, then Platform.environment
  static String get publishableKey {
    final key = dotenv.env['CLERK_PUBLISHABLE_KEY'] ??
        Platform.environment['CLERK_PUBLISHABLE_KEY'] ??
        '';

    if (key.isEmpty) {
      throw StateError(
        'CLERK_PUBLISHABLE_KEY is not set. '
        'Add it to your .env file or set CLERK_PUBLISHABLE_KEY environment variable.',
      );
    }

    if (!key.startsWith('pk_')) {
      throw FormatException(
        'CLERK_PUBLISHABLE_KEY must start with "pk_". '
        'Current value: ${key.substring(0, key.length < 20 ? key.length : 20)}...',
      );
    }

    // Clerk publishable keys are typically 150+ characters
    if (key.length < 100) {
      throw FormatException(
        'CLERK_PUBLISHABLE_KEY appears truncated. '
        'Expected 150+ characters but got ${key.length}. '
        'Please copy the full key from https://dashboard.clerk.com',
      );
    }

    return key;
  }

  /// Clerk Backend URL (for production, use your custom domain)
  static const String backendUrl = 'https://api.clerk.com';

  /// Session token polling interval in seconds
  static const int sessionPollingInterval = 10;

  /// JWT key ID for token verification
  static String get jwtKey => dotenv.env['CLERK_SECRET_KEY'] ?? Platform.environment['CLERK_SECRET_KEY'] ?? '';

  /// Force the app to use production clerk domain
  static const bool useProduction = false;

  /// Whether to automatically restore previous sessions on app startup.
  /// When false, users must explicitly sign in each time the app starts.
  static const bool autoRestoreSession = false;
}
