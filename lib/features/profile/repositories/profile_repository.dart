import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_interceptor.dart';
import 'package:movie_theatre_app/features/profile/models/user_model.dart';

class ProfileRepository {
  String secretKey = "2jukqvNnhunHWMBRRVcZ9ZQ9";
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/user',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<UserModel> getProfileData() async {
    try {
      final response = await dio.get('');
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while getting user data: $e');
    }
  }

  Future<UserModel> changeUserData(String name) async {
    try {
      final response = await dio.post('', data: {"name": name});
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while getting user data: $e');
    }
  }
}
