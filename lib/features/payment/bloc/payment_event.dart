part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class PaymentPay extends PaymentEvent {
  PaymentPay(
      {required this.email,
      required this.cardNumber,
      required this.cvv,
      required this.sessionId,
      required this.seatsIds,
      required this.expirationDate});
  final String email;
  final String cardNumber;
  final String cvv;
  final int sessionId;
  final List<int> seatsIds;
  final String expirationDate;
}
