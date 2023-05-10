import 'package:dio/dio.dart';

import '../../auth/repositories/token_interceptor.dart';

class PaymentRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://fs-mt.qwerty123.tech/api/movies/',
  ))
    ..interceptors.add(TokenInterceptor());

  Future<void> buyTickets(List<int> seats, int sessionId, String email,
      String cardNumber, String cvv, String expirationDate) async {
    try {
      await dio.post('buy', data: {
        "seats": seats,
        "sessionId": sessionId,
        "email": email,
        "cardNumber": cardNumber,
        "expirationDate": expirationDate,
        "cvv": cvv
      });
    } on DioError catch (e) {
      if (e.response != null) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }
}
