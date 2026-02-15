import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:niramoy_health_app/core/data/local/token_storage.dart';

@injectable
class TokenInterceptor extends InterceptorsWrapper {
  static String _bearer(String token) => 'Bearer $token';
  static const _authorization = 'Authorization';

  TokenInterceptor({required this.tokenStorage});

  final TokenStorage tokenStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getToken();
    if (token != null) {
      options.headers[_authorization] = _bearer(token);
    }
    return super.onRequest(options, handler);
  }
}
