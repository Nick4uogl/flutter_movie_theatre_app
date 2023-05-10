import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_theatre_app/features/feed/models/movie_model.dart';
import 'package:movie_theatre_app/features/movie_sessions/sessions_sreen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../ core/widgets/movie_appbar.dart';
import '../../comments/widgets/movie_comments.dart';

class MovieAbout extends StatefulWidget {
  const MovieAbout({super.key, required this.movie});
  final MovieModel movie;

  @override
  State<MovieAbout> createState() => _MovieAboutState();
}

class _MovieAboutState extends State<MovieAbout> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final String? videoId = YoutubePlayer.convertUrlToId(widget.movie.trailer);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideThumbnail: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
      ),
      builder: (context, player) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: const Color(0xff1A2232),
                padding: const EdgeInsets.only(bottom: 90),
                child: ListView(
                  children: [
                    player,
                    const SizedBox(
                      height: 16,
                    ),
                    MovieAboutContent(
                      plot: widget.movie.plot,
                      age: widget.movie.age,
                      year: widget.movie.year,
                      director: widget.movie.director,
                      starring: widget.movie.starring,
                      genre: widget.movie.genre,
                      duration: widget.movie.duration,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MovieComments(
                      movieId: widget.movie.id,
                    ),
                  ],
                ),
              ),
              MovieAppBar(movieName: widget.movie.name),
              MovieAboutBottomButton(
                text: 'Sessions',
                nextPage: SessionPage(
                  movieName: widget.movie.name,
                  movieImage: widget.movie.image,
                  movieId: widget.movie.id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MovieAboutBottomButton extends StatelessWidget {
  const MovieAboutBottomButton({
    super.key,
    required this.text,
    required this.nextPage,
  });

  final Widget nextPage;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: const Color.fromRGBO(31, 41, 61, 0.7),
            height: 88,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => nextPage),
                      );
                    },
                    child: Ink(
                      height: 56,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffFF8036),
                            Color(0xffFC6D19),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MovieAboutContent extends StatelessWidget {
  const MovieAboutContent(
      {super.key,
      required this.plot,
      required this.age,
      required this.year,
      required this.director,
      required this.starring,
      required this.genre,
      required this.duration});

  final String plot;
  final int age;
  final int year;
  final String director;
  final String starring;
  final String genre;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              plot,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Column(
            children: [
              MovieAboutRow(title: 'Age', info: '$age+'),
              const SizedBox(
                height: 12,
              ),
              MovieAboutRow(title: 'Duration', info: '$duration'),
              const SizedBox(
                height: 12,
              ),
              MovieAboutRow(title: 'Release', info: '$year'),
              const SizedBox(
                height: 12,
              ),
              MovieAboutRow(title: 'Genre', info: genre),
              const SizedBox(
                height: 12,
              ),
              MovieAboutRow(title: 'Director', info: director),
              const SizedBox(
                height: 12,
              ),
              MovieAboutRow(title: 'Cast', info: starring),
            ],
          )
        ],
      ),
    );
  }
}

class MovieAboutRow extends StatelessWidget {
  const MovieAboutRow({Key? key, required this.title, required this.info})
      : super(key: key);
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff637394),
            ),
          ),
        ),
        Flexible(
          child: Text(
            info,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
