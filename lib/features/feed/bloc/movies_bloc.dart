import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_theatre_app/features/feed/repositories/movies_repository.dart';

import '../models/movie_model.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  MoviesRepository moviesRepository = MoviesRepository();

  Future<void> _onSearchMovies(event, emit) async {
    try {
      emit(MoviesSearching());
      List<MovieModel> movies =
          await moviesRepository.getMovies(event.date, name: event.name);
      emit(MoviesSearched(movies: movies));
    } catch (e) {
      emit(MoviesError());
    }
  }

  Future<void> _onLoadMovies(event, emit) async {
    try {
      emit(MoviesLoading());
      List<MovieModel> movies = await moviesRepository.getMovies(event.date);
      emit(MoviesLoaded(movies: movies));
    } catch (e) {
      emit(MoviesError());
    }
  }
}
