import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_interceptor.dart';
import 'package:movie_theatre_app/features/movie_sessions/models/session_model.dart';

class SessionRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/movies/sessions',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<List<SessionModel>> getSessions(int id, String date) async {
    final response = await dio.get('?movieId=$id&date=$date');
    try {
      final List sessions = response.data['data'];
      return List.generate(
          sessions.length, (index) => SessionModel.fromJson(sessions[index]));
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching movies: $e');
    }
  }
}
