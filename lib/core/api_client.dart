import 'package:dio/dio.dart';
import 'session.dart';

class ApiClient {
  static final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://greenfox-backend.onrender.com/api',
  );

  final Dio dio;

  ApiClient._(this.dio);

  static ApiClient create() {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Session.instance.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          // No token or invalid token
          await Session.instance.clear();
        }
        handler.next(e);
      },
    ));

    return ApiClient._(dio);
  }
}
