import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_theatre_app/features/payment/bloc/payment_bloc.dart';
import 'package:movie_theatre_app/features/payment/models/card_utils.dart';
import 'package:movie_theatre_app/features/payment/widgets/payment_body.dart';
import 'package:movie_theatre_app/features/payment/widgets/payment_button.dart';
import '../movie_sessions/models/selected_seat.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {Key? key,
      required this.date,
      required this.hallName,
      required this.seats,
      required this.totalPrice,
      required this.sessionId})
      : super(key: key);
  final String date;
  final String hallName;
  final List<SelectedSeat> seats;
  final double totalPrice;
  final int sessionId;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String cardNumber = '';
  String cvv = '';
  String date = '';

  void changeEmail(value) {
    setState(() {
      email = value;
    });
  }

  void changeCardNumber(value) {
    setState(() {
      cardNumber = value;
    });
  }

  void changeCvv(value) {
    setState(() {
      cvv = value;
    });
  }

  void changeDate(value) {
    setState(() {
      date = value;
    });
  }

  List<int> getSeatsIds() {
    return List.generate(
        widget.seats.length, (index) => widget.seats[index].id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Pay for tickets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: PaymentBody(
          data: widget.date,
          hallName: widget.hallName,
          seats: widget.seats,
          totalPrice: widget.totalPrice,
          formKey: _formKey,
          changeEmail: changeEmail,
          changeCvv: changeCvv,
          changeDate: changeDate,
          changeCardNumber: changeCardNumber,
        ),
        bottomNavigationBar: PaymentButton(
          formKey: _formKey,
          email: email,
          cardNumber: CardUtils.getCleanedNumber(cardNumber),
          cvv: cvv,
          sessionId: widget.sessionId,
          seatsIds: getSeatsIds(),
          expirationDate: date,
          //"${CardUtils.getExpiryDate(expirationDateController.text)}",
        ),
      ),
    );
  }
}
