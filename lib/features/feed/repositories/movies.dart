import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_interceptor.dart';
import 'package:movie_theatre_app/features/feed/models/movie_model.dart';

class MoviesRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/movies',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<List<MovieModel>> getMovies(String date, {String? name}) async {
    Response response;

    try {
      if (name != null) {
        response = await dio.get('?date=$date&query=$name');
      } else {
        response = await dio.get('?date=$date');
      }
      final List movies = response.data['data'];
      return List.generate(
          movies.length, (index) => MovieModel.fromJson(movies[index]));
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching movies: $e');
    }
  }
}
