import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/selected_seat.dart';
import '../repositories/book_repository.dart';

part 'movie_sessions_event.dart';
part 'movie_sessions_state.dart';

class MovieSessionsBloc extends Bloc<MovieSessionsEvent, MovieSessionsState> {
  MovieSessionsBloc() : super(MovieSessionsInitial()) {
    deleteExpiredSeats();
    on<SelectSeat>(_onSeatSelect);
    on<DeleteSelectedSeat>(_onDeleteSelectedSeat);
    on<BookSeats>(_onBookSeats);
  }
  List<SelectedSeat> selectedSeats = [];

  void deleteExpiredSeats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bookedSeats = prefs.getStringList('bookedSeats') ?? [];
    bookedSeats.removeWhere((element) {
      var data = element.split('-');
      return DateTime.now().millisecondsSinceEpoch > int.parse(data[1]);
    });
    prefs.setStringList('bookedSeats', bookedSeats);
  }

  void _onSeatSelect(event, emit) {
    selectedSeats.add(SelectedSeat(
      seatNumber: event.seatNumber,
      rowNumber: event.rowNumber,
      price: event.price,
      id: event.id,
    ));
    emit(SeatSelected(selectedSeats: selectedSeats));
  }

  void _onDeleteSelectedSeat(event, emit) {
    selectedSeats.removeWhere((element) =>
        element.seatNumber == event.seatNumber &&
        element.rowNumber == event.rowNumber);
    emit(SeatSelected(selectedSeats: selectedSeats));
  }

  Future<void> _onBookSeats(event, emit) async {
    try {
      emit(BookProgress(selectedSeats: selectedSeats));
      BookRepository bookRepository = BookRepository();
      await bookRepository.bookSeats(event.seats, event.sessionId);

      var localSeats = List.generate(selectedSeats.length, (index) {
        int expiredTime = DateTime.now().millisecondsSinceEpoch + 60000 * 3;
        return '${selectedSeats[index].id}-$expiredTime';
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var savedSeats = sharedPreferences.getStringList('bookedSeats') ?? [];
      sharedPreferences.setStringList('bookedSeats', localSeats + savedSeats);

      emit(SeatsBooked(selectedSeats: selectedSeats));
    } catch (e) {
      emit(
        BookSeatsFailed(
            selectedSeats: selectedSeats,
            errorText: 'An unexpected error occurred while signing in'),
      );
    }
  }
}
