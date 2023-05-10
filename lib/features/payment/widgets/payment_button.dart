import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom_navbar/bloc/bottom_nav_bloc.dart';
import '../bloc/payment_bloc.dart';

class PaymentButton extends StatefulWidget {
  const PaymentButton({
    super.key,
    required this.formKey,
    required this.email,
    required this.cardNumber,
    required this.cvv,
    required this.sessionId,
    required this.seatsIds,
    required this.expirationDate,
  });

  final GlobalKey<FormState> formKey;
  final String email;
  final String cardNumber;
  final String cvv;
  final int sessionId;
  final List<int> seatsIds;
  final String expirationDate;

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  late SharedPreferences sharedPreferences;

  void getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          List<String> bookedSeats =
              sharedPreferences.getStringList('bookedSeats') ?? [];
          if (bookedSeats.isNotEmpty) {
            for (int i = 0; i < widget.seatsIds.length; i++) {
              bookedSeats.removeWhere((element) {
                var data = element.split('-');
                return int.parse(data[0]) == widget.seatsIds[i];
              });
            }
            sharedPreferences.setStringList('bookedSeats', bookedSeats);
          }
          BlocProvider.of<BottomNavBloc>(context)
              .add(ChangeCurrentTab(currentTab: 1));
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: const Color.fromRGBO(31, 41, 61, 0.7),
            height: 88,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  child: BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: (state is PaymentProcess)
                            ? null
                            : () async {
                                if (widget.formKey.currentState!.validate()) {
                                  BlocProvider.of<PaymentBloc>(context).add(
                                    PaymentPay(
                                      email: widget.email,
                                      cardNumber: widget.cardNumber,
                                      cvv: widget.cvv,
                                      sessionId: widget.sessionId,
                                      seatsIds: widget.seatsIds,
                                      expirationDate: widget.expirationDate,
                                    ),
                                  );
                                }
                              },
                        child: Ink(
                          height: 56,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffFF8036),
                                Color(0xffFC6D19),
                              ],
                            ),
                          ),
                          child: Center(
                            child: (state is PaymentProcess)
                                ? const SpinKitDualRing(
                                    color: Colors.white,
                                    size: 40,
                                    lineWidth: 3,
                                  )
                                : const Text(
                                    'Pay',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
