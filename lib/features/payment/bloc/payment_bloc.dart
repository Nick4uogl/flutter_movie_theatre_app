import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_theatre_app/features/payment/models/payment_error.dart';
import 'package:movie_theatre_app/features/payment/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentInitial()) {
    on<PaymentEvent>(_onPaymentPay);
  }

  PaymentRepository paymentRepository = PaymentRepository();

  Future<void> _onPaymentPay(event, emit) async {
    emit(const PaymentProcess(isPayed: false));
    try {
      await paymentRepository.buyTickets(event.seatsIds, event.sessionId,
          event.email, event.cardNumber, event.cvv, event.expirationDate);
      emit(const PaymentSuccess(isPayed: true));
    } on DioError catch (e) {
      if (e.response != null) {
        List resultErrors = e.response?.data['data'];
        var paymentErrors = List.generate(resultErrors.length,
            (index) => PaymentErrorModel.fromJson(resultErrors[index]));
        emit(PaymentError(errors: paymentErrors));
      } else {
        emit(PaymentError(errors: [PaymentErrorModel(error: e.message)]));
      }
    }
  }
}
