part of 'movie_sessions_bloc.dart';

@immutable
abstract class MovieSessionsState {
  const MovieSessionsState({this.selectedSeats});
  final List<SelectedSeat>? selectedSeats;
}

class MovieSessionsInitial extends MovieSessionsState {
  MovieSessionsInitial() : super(selectedSeats: []);
}

class SeatSelected extends MovieSessionsState {
  const SeatSelected({super.selectedSeats});
}

class SelectedSeatDeleted extends MovieSessionsState {
  const SelectedSeatDeleted({super.selectedSeats});
}

class BookProgress extends MovieSessionsState {
  const BookProgress({super.selectedSeats});
}

class SeatsExpired extends MovieSessionsState {
  const SeatsExpired({super.selectedSeats});
}

class SeatsBooked extends MovieSessionsState {
  const SeatsBooked({super.selectedSeats});
}

class BookSeatsFailed extends MovieSessionsState {
  const BookSeatsFailed({required this.errorText, super.selectedSeats});
  final String errorText;
}
