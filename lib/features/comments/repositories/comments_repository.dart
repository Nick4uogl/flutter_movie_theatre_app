import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_interceptor.dart';
import 'package:movie_theatre_app/features/comments/models/comments_model.dart';

class CommentsRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/movies/comments',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<List<CommentModel>> getComments(int movieId) async {
    try {
      final response = await dio.get('?movieId=$movieId');
      List data = response.data['data'];
      return List.generate(
          data.length, (index) => CommentModel.fromJson(data[index]));
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while getting comments: $e');
    }
  }

  Future<void> addComment(int id, int rating, String content) async {
    try {
      await dio.post('', data: {
        "content": content,
        "rating": rating,
        "movieId": id,
      });
    } catch (e) {
      throw Exception('An unexpected error occurred while adding comment: $e');
    }
  }

  Future<void> deleteComment(int id) async {
    try {
      await dio.delete('/$id');
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while deleting comment: $e');
    }
  }
}
