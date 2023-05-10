import 'package:flutter/material.dart';

class MovieAppBar extends StatelessWidget {
  const MovieAppBar({super.key, required this.movieName});
  final String movieName;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        //color: Color(0xff1A2232),
        color: Colors.transparent,
        margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        height: 52,
        child: Stack(
          children: [
            Center(
              child: Text(
                movieName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 2,
              left: 28,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
