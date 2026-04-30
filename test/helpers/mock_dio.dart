import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

/// Mock Dio client for testing network layer
class MockDio extends Mock implements Dio {}

/// Factory for creating pre-configured MockDio instances
class MockDioFactory {
  /// Creates a mock that returns [responseData] on GET requests
  static MockDio createGetMock({
    required String path,
    required dynamic responseData,
    int statusCode = 200,
  }) {
    final mock = MockDio();
    final response = Response(
      requestOptions: RequestOptions(path: path),
      statusCode: statusCode,
      data: responseData,
    );

    when(() => mock.get(
      any(),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'),
      cancelToken: any(named: 'cancelToken'),
    )).thenAnswer((_) async => response);

    return mock;
  }

  /// Creates a mock that returns [responseData] on POST requests
  static MockDio createPostMock({
    required String path,
    required dynamic responseData,
    int statusCode = 200,
  }) {
    final mock = MockDio();
    final response = Response(
      requestOptions: RequestOptions(path: path),
      statusCode: statusCode,
      data: responseData,
    );

    when(() => mock.post(
      any(),
      data: any(named: 'data'),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'),
      cancelToken: any(named: 'cancelToken'),
    )).thenAnswer((_) async => response);

    return mock;
  }

  /// Creates a mock that simulates a timeout error
  static MockDio createTimeoutMock({required String path}) {
    final mock = MockDio();

    when(() => mock.get(
      any(),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'),
      cancelToken: any(named: 'cancelToken'),
    )).thenThrow(DioException(
      requestOptions: RequestOptions(path: path),
      type: DioExceptionType.connectionTimeout,
      message: 'Connection timeout',
    ));

    return mock;
  }

  /// Creates a mock that simulates a server error (500)
  static MockDio createServerErrorMock({
    required String path,
    int statusCode = 500,
    String message = 'Internal server error',
  }) {
    final mock = MockDio();
    final response = Response(
      requestOptions: RequestOptions(path: path),
      statusCode: statusCode,
      data: {'error': message},
    );

    when(() => mock.get(
      any(),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'),
      cancelToken: any(named: 'cancelToken'),
    )).thenAnswer((_) async => response);

    return mock;
  }

  /// Creates a mock that simulates malformed JSON response
  static MockDio createMalformedJsonMock({required String path}) {
    final mock = MockDio();

    when(() => mock.get(
      any(),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'),
      cancelToken: any(named: 'cancelToken'),
    )).thenThrow(DioException(
      requestOptions: RequestOptions(path: path),
      type: DioExceptionType.badResponse,
      message: 'Bad response',
      response: Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: 'not valid json {',
      ),
    ));

    return mock;
  }

  /// Creates a mock that simulates network connectivity error
  static MockDio createNetworkErrorMock({required String path}) {
    final mock = MockDio();

    when(() => mock.get(
      any(),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'),
      cancelToken: any(named: 'cancelToken'),
    )).thenThrow(DioException(
      requestOptions: RequestOptions(path: path),
      type: DioExceptionType.connectionError,
      message: 'Connection error',
      error: 'SocketException',
    ));

    return mock;
  }
}