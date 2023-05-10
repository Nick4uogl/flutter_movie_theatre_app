part of 'movies_bloc.dart';

@immutable
abstract class MoviesEvent {
  const MoviesEvent({required this.date});
  final String date;
}

class LoadMovies extends MoviesEvent {
  const LoadMovies({required super.date});
}

class SearchMovies extends MoviesEvent {
  const SearchMovies({required super.date, required this.name});
  final String name;
}
