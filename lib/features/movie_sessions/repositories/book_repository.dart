import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_interceptor.dart';

class BookRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/movies/book',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<void> bookSeats(List<int> seats, int sessionId) async {
    try {
      await dio.post('', data: {
        "seats": seats,
        "sessionId": sessionId,
      });
    } catch (e) {
      throw Exception('An unexpected error occurred while booking seats: $e');
    }
  }
}
