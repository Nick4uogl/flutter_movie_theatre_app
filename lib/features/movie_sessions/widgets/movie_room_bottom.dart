import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ core/utils/months.dart';
import '../../payment/payment_screen.dart';
import '../bloc/movie_sessions_bloc.dart';
import '../models/session_model.dart';
import 'bottom_nav_button.dart';

class MovieRoomBottom extends StatefulWidget {
  const MovieRoomBottom({Key? key, required this.session}) : super(key: key);
  final SessionModel session;

  @override
  State<MovieRoomBottom> createState() => _MovieRoomBottomState();
}

class _MovieRoomBottomState extends State<MovieRoomBottom> {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieSessionsBloc, MovieSessionsState>(
      builder: (context, state) {
        int getTotalPrice() {
          var totalPrice = 0;
          var selectedSeats = state.selectedSeats!;
          for (int i = 0; i < selectedSeats.length; i++) {
            totalPrice += selectedSeats[i].price;
          }

          return totalPrice;
        }

        if (state.selectedSeats!.isNotEmpty) {
          return FutureBuilder(
              future: sharedPreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<int>? getSeatsIds() {
                    var selectedSeats = [...state.selectedSeats!];
                    List<String>? bookedSeats = [];
                    if (snapshot.data != null) {
                      bookedSeats = snapshot.data!.getStringList('bookedSeats');
                    }

                    if (bookedSeats != null) {
                      var bookedSeatsIds = [];
                      for (int i = 0; i < bookedSeats.length; i++) {
                        var data = bookedSeats[i].split('-');
                        if (DateTime.now().millisecondsSinceEpoch <
                            int.parse(data[1])) {
                          bookedSeatsIds.add(int.parse(data[0]));
                        }
                      }
                      if (bookedSeatsIds.isNotEmpty &&
                          selectedSeats.isNotEmpty) {
                        for (int j = 0; j < bookedSeatsIds.length; j++) {
                          selectedSeats.removeWhere(
                              (element) => element.id == bookedSeatsIds[j]);
                        }
                      }
                      bookedSeats.removeWhere((element) {
                        var data = element.split('-');
                        return DateTime.now().millisecondsSinceEpoch >
                            int.parse(data[1]);
                      });
                      snapshot.data!.setStringList('bookedSeats', bookedSeats);
                    }

                    return List.generate(selectedSeats.length,
                        (index) => selectedSeats[index].id);
                  }

                  var date = DateTime.fromMillisecondsSinceEpoch(
                      widget.session.date * 1000);
                  var formattedTime = DateFormat.Hm().format(date);
                  var day = DateFormat.d().format(date);
                  var now = DateTime.now();
                  var currentMonth = now.month;

                  double totalPrice = 0;
                  for (int i = 0; i < state.selectedSeats!.length; i++) {
                    totalPrice += state.selectedSeats![i].price;
                  }

                  return BottomNavButton(
                    text: 'Continue',
                    nextPage: PaymentPage(
                      date:
                          '$day ${Months.months[currentMonth - 1]}, $formattedTime',
                      hallName: widget.session.room.name,
                      seats: state.selectedSeats!,
                      totalPrice: totalPrice,
                      sessionId: widget.session.id,
                    ),
                    totalPrice: getTotalPrice(),
                    sessionId: widget.session.id,
                    seats: getSeatsIds(),
                  );
                }
                return const SpinKitDualRing(
                  color: Color(0xff637394),
                  lineWidth: 3,
                );
              });
        }
        return const SizedBox();
      },
    );
  }
}
