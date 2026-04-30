import 'package:mocktail/mocktail.dart';

/// Generic mock for repository interfaces
/// Use this as a base for creating specific repository mocks
class MockRepository<T> extends Mock {
  // Generic mock - specialize in subclasses
}

/// Helper mixin for repository tests providing common setup
mixin RepositoryTestHelper<T> {
  /// Override this in your test to set up mock fallback values
  void setupDefaultFallback();

  /// Verify the repository method was called exactly once
  void verifyCalledOnce(dynamic method);

  /// Verify the repository was called with specific arguments
  void verifyCalledWith(dynamic method, dynamic args);
}

/// Extension to make it easier to set up mock answers
extension MockRepositoryExtension<T> on MockRepository<T> {
  /// Sets up a mock to return [value] when [method] is called
  void whenCall(dynamic method, Object? value) {
    when(method).thenAnswer((_) async => value);
  }

  /// Sets up a mock to throw [exception] when [method] is called
  void whenThrows(dynamic method, Exception exception) {
    when(method).thenThrow(exception);
  }
}