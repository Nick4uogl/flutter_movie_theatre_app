import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_theatre_app/features/movie_sessions/bloc/movie_sessions_bloc.dart';

import '../models/selected_seat.dart';
import '../models/session_model.dart';

class SeatImage extends StatelessWidget {
  const SeatImage({Key? key, required this.seat, required this.localSeats})
      : super(key: key);
  final Seat seat;
  final List<int> localSeats;

  @override
  Widget build(BuildContext context) {
    List<SelectedSeat> selectedSeats =
        BlocProvider.of<MovieSessionsBloc>(context).state.selectedSeats!;
    bool isSelected = false;

    for (int i = 0; i < selectedSeats.length; i++) {
      if (selectedSeats[i].id == seat.id) {
        isSelected = true;
      }
    }
    if (!seat.isAvailable && !localSeats.contains(seat.id)) {
      return SvgPicture.asset(
        'assets/img/icons/seatReserved.svg',
        width: 22,
        height: 15,
      );
    } else if (isSelected) {
      return SvgPicture.asset(
        'assets/img/icons/seatSelected.svg',
        width: 22,
        height: 15,
      );
    } else if (seat.type == 1) {
      return SvgPicture.asset(
        'assets/img/icons/seatBetter.svg',
        width: 22,
        height: 15,
      );
    } else if (seat.type == 2) {
      return SvgPicture.asset(
        'assets/img/icons/seatVip.svg',
        width: 22,
        height: 15,
      );
    }
    return SvgPicture.asset(
      'assets/img/icons/seatAvailable.svg',
      width: 22,
      height: 15,
    );
  }
}
