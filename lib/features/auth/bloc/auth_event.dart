part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStart extends AuthEvent {}

class AuthSuccess extends AuthEvent {}

class AuthError extends AuthEvent {}
