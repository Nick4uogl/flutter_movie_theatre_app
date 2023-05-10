import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/token_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(bool isAuthorized) : super(AuthInitial(isAuthorized: isAuthorized)) {
    on<AuthStart>(signInUser);
  }

  Future<void> signInUser(AuthEvent event, Emitter<AuthState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!state.isAuthorized) {
      try {
        emit(AuthProgress());
        var accessToken = await TokenRepository().getAccessToken();
        prefs.setString('token', accessToken);
        emit(AuthSucced(isAuthorized: true));
        print(accessToken);
      } catch (e) {
        emit(AuthFailed(
            errorText: 'An unexpected error occurred while signing in'));
      }
    } else {
      print('token already exists');
    }
  }
}
