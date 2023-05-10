part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {
  const PaymentState({required this.isPayed, this.errors});
  final bool isPayed;
  final List<PaymentErrorModel>? errors;
}

class PaymentInitial extends PaymentState {
  const PaymentInitial({super.isPayed = false});
}

class PaymentProcess extends PaymentState {
  const PaymentProcess({required super.isPayed});
}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess({required super.isPayed});
}

class PaymentError extends PaymentState {
  const PaymentError({super.isPayed = false, required super.errors});
}
