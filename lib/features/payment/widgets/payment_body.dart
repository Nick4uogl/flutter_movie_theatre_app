import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_theatre_app/features/payment/widgets/payment_errors.dart';
import 'package:movie_theatre_app/features/payment/widgets/payment_info_row.dart';
import 'package:movie_theatre_app/features/payment/widgets/payment_inputs.dart';

import '../../movie_sessions/models/selected_seat.dart';

class PaymentBody extends StatelessWidget {
  const PaymentBody(
      {Key? key,
      required this.data,
      required this.hallName,
      required this.seats,
      required this.totalPrice,
      required this.formKey,
      required this.changeEmail,
      required this.changeCvv,
      required this.changeDate,
      required this.changeCardNumber})
      : super(key: key);
  final String data;
  final String hallName;
  final List<SelectedSeat> seats;
  final double totalPrice;
  final GlobalKey<FormState> formKey;
  final Function changeEmail;
  final Function changeCvv;
  final Function changeDate;
  final Function changeCardNumber;

  String getSeats() {
    String seatsStr = '';
    for (int i = 0; i < seats.length; i++) {
      if (i == seats.length - 1) {
        seatsStr += '${seats[i].rowNumber} row (${seats[i].seatNumber})';
      } else {
        seatsStr += '${seats[i].rowNumber} row (${seats[i].seatNumber}), ';
      }
    }

    return seatsStr;
  }

  String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Please enter in a format some@example.com';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1A2232),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: ListView(children: [
        Column(children: [
          Container(
            width: 375,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: const Color(0xff1F293D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The batman',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MovieInfoRow(title: 'Date', info: data),
                      const SizedBox(
                        height: 12,
                      ),
                      MovieInfoRow(title: 'Room', info: hallName),
                      const SizedBox(
                        height: 12,
                      ),
                      MovieInfoRow(title: 'Seats', info: getSeats()),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 16,
                        ),
                        padding: const EdgeInsets.only(top: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(109, 158, 255, 0.1),
                            ),
                          ),
                        ),
                        child: MovieInfoRow(
                          title: 'Total',
                          info: '$totalPrice UAH',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: SvgPicture.asset(
                    'assets/img/icons/tearLine.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PaymentErrors(),
                        PaymentEmailInput(
                          hintText: 'Email',
                          validator: (value) {
                            return emailValidator(value);
                          },
                          changeEmail: changeEmail,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PaymentCardInput(
                          changeCardNumber: changeCardNumber,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: PaymentCvvInput(
                                changeCvv: changeCvv,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: PaymentExpirationInput(
                                  changeDate: changeDate),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}
