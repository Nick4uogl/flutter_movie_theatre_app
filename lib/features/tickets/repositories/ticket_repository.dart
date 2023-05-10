import 'package:dio/dio.dart';
import 'package:movie_theatre_app/features/auth/repositories/token_interceptor.dart';
import 'package:movie_theatre_app/features/tickets/models/ticket_model.dart';

class TicketRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/user/tickets',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<List<TicketModel>> getTickets() async {
    try {
      final response = await dio.get('');
      final List data = response.data['data'];
      return List.generate(
          data.length, (index) => TicketModel.fromJson(data[index]));
    } catch (e) {
      throw Exception(
          'An unexpected error occurred while fetching tickets: $e');
    }
  }
}
