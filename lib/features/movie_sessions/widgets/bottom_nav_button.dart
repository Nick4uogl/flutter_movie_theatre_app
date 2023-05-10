import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_theatre_app/features/movie_sessions/repositories/book_repository.dart';

import '../bloc/movie_sessions_bloc.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton(
      {super.key,
      required this.text,
      required this.nextPage,
      this.totalPrice,
      this.seats,
      this.sessionId});

  final Widget nextPage;
  final String text;
  final int? totalPrice;
  final List<int>? seats;
  final int? sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieSessionsBloc, MovieSessionsState>(
      listener: (context, state) {
        if (state is SeatsBooked) {
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => nextPage),
            );
          }
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: const Color.fromRGBO(31, 41, 61, 0.7),
              height: totalPrice != null ? 128 : 88,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (totalPrice != 0 && totalPrice != null)
                    Text(
                      'Total: $totalPrice UAH',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  if (totalPrice != 0 && totalPrice != null)
                    const SizedBox(
                      height: 18,
                    ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          if (seats!.isNotEmpty) {
                            BlocProvider.of<MovieSessionsBloc>(context).add(
                              BookSeats(sessionId: sessionId!, seats: seats!),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => nextPage),
                            );
                          }
                        },
                        child: Ink(
                          width: double.infinity,
                          height: 56,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffFF8036),
                                Color(0xffFC6D19),
                              ],
                            ),
                          ),
                          child: Center(
                            child: BlocBuilder<MovieSessionsBloc,
                                MovieSessionsState>(
                              builder: (context, state) {
                                if (state is BookProgress) {
                                  return const SpinKitDualRing(
                                    color: Colors.white,
                                    size: 40,
                                    lineWidth: 3,
                                  );
                                }
                                return Text(
                                  text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
