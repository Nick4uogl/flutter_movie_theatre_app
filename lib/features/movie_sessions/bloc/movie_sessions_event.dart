part of 'movie_sessions_bloc.dart';

@immutable
abstract class MovieSessionsEvent {}

class SelectSeat extends MovieSessionsEvent {
  SelectSeat({
    required this.rowNumber,
    required this.price,
    required this.seatNumber,
    required this.id,
  });
  final int seatNumber;
  final int rowNumber;
  final int price;
  final int id;
}

class DeleteSelectedSeat extends MovieSessionsEvent {
  DeleteSelectedSeat({
    required this.rowNumber,
    required this.seatNumber,
  });
  final int seatNumber;
  final int rowNumber;
}

class BookSeats extends MovieSessionsEvent {
  BookSeats({required this.sessionId, required this.seats});
  final List<int> seats;
  final int sessionId;
}

class DeleteExpiredSeats extends MovieSessionsEvent {}
