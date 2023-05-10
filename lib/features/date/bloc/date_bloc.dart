import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'date_event.dart';
part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(DateInitial()) {
    on<ChangeDate>(_onDateChanged);
  }

  void _onDateChanged(event, emit) {
    emit(DateChanged(date: event.date));
  }
}
