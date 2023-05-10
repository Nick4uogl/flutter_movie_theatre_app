part of 'movies_bloc.dart';

@immutable
abstract class MoviesState {
  const MoviesState({this.movies});
  final List<MovieModel>? movies;
}

class MoviesInitial extends MoviesState {
  MoviesInitial() : super(movies: []);
}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  const MoviesLoaded({required super.movies});
}

class MoviesError extends MoviesState {}

class MoviesSearchError extends MoviesState {}

class MoviesSearching extends MoviesState {}

class MoviesSearched extends MoviesState {
  const MoviesSearched({required super.movies});
}
