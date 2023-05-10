part of 'auth_bloc.dart';

abstract class AuthState {
  AuthState({this.isAuthorized = false});
  bool isAuthorized;
}

class AuthInitial extends AuthState {
  AuthInitial({super.isAuthorized});
}

class AuthProgress extends AuthState {
  AuthProgress({super.isAuthorized});
}

class AuthSucced extends AuthState {
  AuthSucced({super.isAuthorized});
}

class AuthFailed extends AuthState {
  AuthFailed({super.isAuthorized, required this.errorText});
  String errorText;
}
