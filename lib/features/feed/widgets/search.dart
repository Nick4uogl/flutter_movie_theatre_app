import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_theatre_app/features/feed/bloc/movies_bloc.dart';
import 'package:movie_theatre_app/features/feed/repositories/movies_repository.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({Key? key}) : super(key: key);

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  late TextEditingController _controller;
  late MoviesRepository moviesRepository;

  @override
  void initState() {
    super.initState();
    moviesRepository = MoviesRepository();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(
        color: Color.fromRGBO(99, 115, 148, 0.6),
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      onSubmitted: (value) async {
        BlocProvider.of<MoviesBloc>(context)
            .add(SearchMovies(date: '2023-05-18', name: value));
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xff637394),
        ),
        fillColor: const Color.fromRGBO(118, 118, 128, 0.12),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Color.fromRGBO(99, 115, 148, 0.6),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
