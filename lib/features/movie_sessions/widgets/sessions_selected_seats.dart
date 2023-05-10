import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/movie_sessions_bloc.dart';

class SessionSelectedSeats extends StatelessWidget {
  const SessionSelectedSeats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieSessionsBloc, MovieSessionsState>(
      builder: (context, state) {
        var selectedSeats = state.selectedSeats!;
        return Column(
          children: List.generate(
            selectedSeats.length,
            (index) => Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xff6D9EFF),
                  ),
                ),
              ),
              height: 40,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              '${selectedSeats[index].rowNumber} row',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${selectedSeats[index].seatNumber} seat',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${selectedSeats[index].price} UAH',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 13,
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/img/icons/delete.svg'),
                    //onPressed: deleteSelectedSeat(seatNumber, rowNumber),
                    onPressed: () {
                      context.read<MovieSessionsBloc>().add(
                            DeleteSelectedSeat(
                              rowNumber: selectedSeats[index].rowNumber,
                              seatNumber: selectedSeats[index].seatNumber,
                            ),
                          );
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
