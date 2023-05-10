part of 'date_bloc.dart';

@immutable
abstract class DateEvent {
  const DateEvent({required this.date});
  final DateTime date;
}

class ChangeDate extends DateEvent {
  const ChangeDate({required super.date});
}
