import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clerk Authentication Configuration
class ClerkConfig {
  /// Clerk Publishable Key
  static String get publishableKey => dotenv.env['CLERK_PUBLISHABLE_KEY'] ?? '';

  /// Clerk Backend URL (for production, use your custom domain)
  static const String backendUrl = 'https://api.clerk.com';

  /// Session token polling interval in seconds
  static const int sessionPollingInterval = 10;

  /// JWT key ID for token verification
  static String get jwtKey => dotenv.env['CLERK_SECRET_KEY'] ?? '';

  /// Force the app to use production clerk domain
  static const bool useProduction = false;
}
