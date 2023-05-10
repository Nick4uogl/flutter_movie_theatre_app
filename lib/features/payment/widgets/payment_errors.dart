import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/payment_bloc.dart';

class PaymentErrors extends StatelessWidget {
  const PaymentErrors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        if (state is PaymentError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              state.errors!.length,
              (index) => Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  state.errors![index].error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
