import 'package:dio/dio.dart';
import 'session.dart';

class ApiClient {
  static final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api', // Android emulator to localhost
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
        if (await Session.instance.hasToken()) {
          options.headers['Authorization'] = 'Bearer ${Session.instance.token}';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await Session.instance.clear();
        }
        handler.next(e);
      },
    ));

    return ApiClient._(dio);
  }
}
//https://greenfox-backend.onrender.com/api