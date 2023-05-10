part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class FetchUserData extends UserEvent {}

class ChangeUserData extends UserEvent {
  ChangeUserData({required this.name});
  final String name;
}
