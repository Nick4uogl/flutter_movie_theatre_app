import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_repository.dart';

class TokenInterceptor extends Interceptor {
  final TokenRepository tokenRepository = TokenRepository();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenRepository.getAccessToken();
    if (options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    super.onRequest(options, handler);
  }
}
