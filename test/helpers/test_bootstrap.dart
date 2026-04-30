import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Bootstrap file that runs before all tests to initialize test environment
void bootstrapTests() {
  // Initialize DotEnv for tests with mock values
  dotenv.testLoad(
    mergeWith: {
      'API_BASE_URL': 'http://localhost:8082',
      'CLERK_PUBLISHABLE_KEY': 'test_key',
    },
  );
}
