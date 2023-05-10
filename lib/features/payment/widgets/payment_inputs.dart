import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/card_utils.dart';

class PaymentCardInput extends StatelessWidget {
  const PaymentCardInput({Key? key, required this.changeCardNumber})
      : super(key: key);
  final Function changeCardNumber;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        changeCardNumber(value);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        CardNumberInputFormatter(),
      ],
      validator: (value) {
        String? result = CardUtils.validateCardNum(value);
        return result;
      },
      style: const TextStyle(
        color: Color.fromRGBO(99, 115, 148, 0.6),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: 'Card number',
        hintStyle: const TextStyle(
          color: Color.fromRGBO(99, 115, 148, 0.6),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PaymentExpirationInput extends StatelessWidget {
  const PaymentExpirationInput({Key? key, required this.changeDate})
      : super(key: key);
  final Function changeDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        changeDate(value);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
        CardMonthInputFormatter(),
      ],
      validator: (value) {
        String? result = CardUtils.validateDate(value);
        return result;
      },
      style: const TextStyle(
        color: Color.fromRGBO(99, 115, 148, 0.6),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: 'MM/YY',
        hintStyle: const TextStyle(
          color: Color.fromRGBO(99, 115, 148, 0.6),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PaymentCvvInput extends StatelessWidget {
  const PaymentCvvInput({Key? key, required this.changeCvv}) : super(key: key);
  final Function changeCvv;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      onChanged: (value) {
        changeCvv(value);
      },
      validator: (value) {
        String? result = CardUtils.validateCVV(value);
        return result;
      },
      style: const TextStyle(
        color: Color.fromRGBO(99, 115, 148, 0.6),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: 'CVV',
        hintStyle: const TextStyle(
          color: Color.fromRGBO(99, 115, 148, 0.6),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PaymentEmailInput extends StatelessWidget {
  const PaymentEmailInput(
      {Key? key,
      required this.hintText,
      required this.validator,
      required this.changeEmail})
      : super(key: key);
  final String hintText;
  final String? Function(String?) validator;
  final Function changeEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onChanged: (value) {
        changeEmail(value);
      },
      style: const TextStyle(
        color: Color.fromRGBO(99, 115, 148, 0.6),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(0xff637394),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(99, 115, 148, 0.6),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
