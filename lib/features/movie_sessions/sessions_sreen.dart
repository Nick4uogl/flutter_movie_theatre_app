import 'package:flutter/material.dart';
import 'package:movie_theatre_app/%20core/widgets/movie_image.dart';
import 'package:movie_theatre_app/features/movie_sessions/widgets/sessions_body.dart';

import '../../ core/widgets/movie_appbar.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({
    super.key,
    required this.movieName,
    required this.movieImage,
    required this.movieId,
  });
  final String movieName;
  final String movieImage;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: const Color(0xff1A2232),
          child: ListView(
            children: [
              MovieImage(image: movieImage),
              const SessionPagePricesPanel(),
              SessionPageBody(
                movieName: movieName,
                movieImage: movieImage,
                movieId: movieId,
              ),
            ],
          ),
        ),
        MovieAppBar(movieName: movieName),
      ]),
    );
  }
}

class SessionPagePricesPanel extends StatelessWidget {
  const SessionPagePricesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff253554),
      height: 30,
      child: Row(
        children: const [
          Expanded(
            child: Center(
              child: Text(
                'Time',
                style: TextStyle(
                  color: Color(0xff637394),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Normal',
                style: TextStyle(
                  color: Color(0xff637394),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Better',
                style: TextStyle(
                  color: Color(0xff637394),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Vip',
                style: TextStyle(
                  color: Color(0xff637394),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
