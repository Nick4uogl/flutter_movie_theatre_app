part of 'user_bloc.dart';

@immutable
abstract class UserState {
  const UserState({this.name = ''});
  final String name;
}

class UserInitial extends UserState {}

class FetchingUserData extends UserState {}

class UserDataFetched extends UserState {
  const UserDataFetched({required super.name});
}

class UserDataError extends UserState {}
