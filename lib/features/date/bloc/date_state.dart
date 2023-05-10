part of 'date_bloc.dart';

@immutable
abstract class DateState {
  const DateState({required this.date});
  final DateTime date;
}

class DateInitial extends DateState {
  DateInitial() : super(date: DateTime.now());
}

class DateChanged extends DateState {
  const DateChanged({required super.date});
}
