import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:movie_theatre_app/%20core/utils/months.dart';
import 'package:movie_theatre_app/%20core/widgets/movie_appbar.dart';
import 'package:movie_theatre_app/features/movie_sessions/bloc/movie_sessions_bloc.dart';
import 'package:movie_theatre_app/features/movie_sessions/models/session_model.dart';
import 'package:movie_theatre_app/features/movie_sessions/widgets/seat_image.dart';
import 'package:movie_theatre_app/features/movie_sessions/widgets/sessions_selected_seats.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'movie_room_bottom.dart';

class MovieRoom extends StatefulWidget {
  const MovieRoom(
      {super.key,
      required this.movieName,
      required this.image,
      required this.session});
  final String movieName;
  final String image;
  final SessionModel session;

  @override
  State<MovieRoom> createState() => _MovieRoomState();
}

class _MovieRoomState extends State<MovieRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MovieSessionsBloc(),
        child: Stack(
          children: [
            Container(
              color: const Color(0xff1A2232),
              padding: const EdgeInsets.only(top: 65, bottom: 100),
              child: ListView(
                children: [
                  MovieScreenImage(
                    image: widget.image,
                  ),
                  Stack(children: [
                    const MovieScreenShadow(),
                    BlocBuilder<MovieSessionsBloc, MovieSessionsState>(
                      builder: (context, state) {
                        return MovieSeats(
                          session: widget.session,
                        );
                      },
                    ),
                  ]),
                  MovieSessionInfo(
                    session: widget.session,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  const SessionSelectedSeats(),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            MovieRoomBottom(session: widget.session),
            MovieAppBar(movieName: widget.movieName),
          ],
        ),
      ),
    );
  }
}

class MovieSessionInfo extends StatelessWidget {
  const MovieSessionInfo({Key? key, required this.session}) : super(key: key);
  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          const SeatsDescription(),
          const SizedBox(
            height: 11,
          ),
          MovieDate(session: session),
        ],
      ),
    );
  }
}

class MovieSeats extends StatelessWidget {
  const MovieSeats({
    super.key,
    required this.session,
  });
  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 49),
      child: InteractiveViewer(
        maxScale: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(session.room.rows.length, (index) {
            var row = session.room.rows[index];
            return Container(
              margin: index != session.room.rows.length - 1
                  ? const EdgeInsets.only(bottom: 12)
                  : EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(row.seats.length, (index) {
                  return MovieSeat(
                    row: row,
                    index: index,
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MovieSeat extends StatefulWidget {
  const MovieSeat({
    Key? key,
    required this.row,
    required this.index,
  }) : super(key: key);
  final SeatsRow row;
  final int index;
  @override
  State<MovieSeat> createState() => _MovieSeatState();
}

class _MovieSeatState extends State<MovieSeat> {
  bool isSelected = false;
  late final Future<SharedPreferences> sharedPreferences;

  @override
  void initState() {
    super.initState();
    sharedPreferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var seat = widget.row.seats[widget.index];
    return FutureBuilder(
        future: sharedPreferences,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String>? bookedSeats = [];
            if (snapshot.data != null) {
              bookedSeats = snapshot.data!.getStringList('bookedSeats');
            }
            List<int> bookedSeatsIds = [];

            if (bookedSeats != null) {
              for (int i = 0; i < bookedSeats.length; i++) {
                var data = bookedSeats[i].split('-');
                if (DateTime.now().millisecondsSinceEpoch <
                    int.parse(data[1])) {
                  bookedSeatsIds.add(int.parse(data[0]));
                }
              }
              bookedSeats.removeWhere((element) {
                var data = element.split('-');
                return DateTime.now().millisecondsSinceEpoch >
                    int.parse(data[1]);
              });
              snapshot.data!.setStringList('bookedSeats', bookedSeats);
            }

            return GestureDetector(
              onTap: (seat.isAvailable || bookedSeatsIds.contains(seat.id))
                  ? () => setState(() {
                        if (isSelected) {
                          isSelected = false;
                          context.read<MovieSessionsBloc>().add(
                                DeleteSelectedSeat(
                                  rowNumber: widget.row.index,
                                  seatNumber: seat.index,
                                ),
                              );
                        } else {
                          isSelected = true;
                          context.read<MovieSessionsBloc>().add(
                                SelectSeat(
                                  price: seat.price,
                                  rowNumber: widget.row.index,
                                  seatNumber: seat.index,
                                  id: seat.id,
                                ),
                              );
                        }
                      })
                  : null,
              child: Container(
                margin: widget.index != widget.row.seats.length
                    ? const EdgeInsets.only(right: 6)
                    : EdgeInsets.zero,
                child: SeatImage(
                  localSeats: bookedSeatsIds,
                  seat: seat,
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}

class MovieDate extends StatefulWidget {
  const MovieDate({super.key, required this.session});
  final SessionModel session;

  @override
  State<MovieDate> createState() => _MovieDateState();
}

class _MovieDateState extends State<MovieDate> {
  late String formattedTime;
  late String day;
  late int currentMonth;

  @override
  void initState() {
    var date = DateTime.fromMillisecondsSinceEpoch(widget.session.date * 1000);
    formattedTime = DateFormat.Hm().format(date);
    day = DateFormat.d().format(date);
    var now = DateTime.now();
    currentMonth = now.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/img/icons/calendar.svg'),
        const SizedBox(
          width: 10,
        ),
        Text(
          'Session:  $formattedTime, ${Months.months[currentMonth - 1]} $day',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Color(0xff637394),
          ),
        ),
      ],
    );
  }
}

class MovieScreenImage extends StatelessWidget {
  const MovieScreenImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipPath(
        clipper: MovieScreenClipper(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MovieScreenShadow extends StatelessWidget {
  const MovieScreenShadow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MovieScreenShadowClipper(),
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(196, 196, 196, 0.2),
              Color.fromRGBO(196, 196, 196, 0),
            ],
          ),
        ),
      ),
    );
  }
}

class SeatsDescription extends StatelessWidget {
  const SeatsDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 28),
      width: double.infinity,
      child: Wrap(
        runSpacing: 12,
        children: const [
          SeatLabel(
              image: 'assets/img/icons/seatAvailable.svg', text: 'Available'),
          SizedBox(
            width: 16,
          ),
          SeatLabel(
              image: 'assets/img/icons/seatReserved.svg', text: 'Occupied'),
          SizedBox(
            width: 16,
          ),
          SeatLabel(
              image: 'assets/img/icons/seatSelected.svg', text: 'Selected'),
          SizedBox(
            width: 16,
          ),
          SeatLabel(image: 'assets/img/icons/seatVip.svg', text: 'Vip'),
          SizedBox(
            width: 16,
          ),
          SeatLabel(image: 'assets/img/icons/seatBetter.svg', text: 'Better'),
        ],
      ),
    );
  }
}

class SeatLabel extends StatelessWidget {
  const SeatLabel({super.key, required this.image, required this.text});
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(image),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

class MovieScreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width * 0.8910773, size.height);
    path0.lineTo(size.width * 0.1108287, size.height);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MovieScreenShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.1150276, 0);
    path0.lineTo(size.width * 0.8873757, 0);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(size.width * 0.1150276, 0);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
