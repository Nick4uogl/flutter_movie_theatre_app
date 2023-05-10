import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_theatre_app/features/profile/models/user_model.dart';
import 'package:movie_theatre_app/features/profile/repositories/profile_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FetchUserData>(_onFetchUserData);
    on<ChangeUserData>(_onChangeUserData);
  }

  ProfileRepository profileRepository = ProfileRepository();

  String getRandomUserName() {
    String userName = 'user';
    var rng = Random();
    for (var i = 0; i < 7; i++) {
      userName += rng.nextInt(9).toString();
    }
    return userName;
  }

  Future<void> _onFetchUserData(event, emit) async {
    try {
      emit(FetchingUserData());
      UserModel userData = await profileRepository.getProfileData();
      emit(UserDataFetched(name: userData.name ?? getRandomUserName()));
    } catch (e) {
      emit(UserDataError());
    }
  }

  Future<void> _onChangeUserData(event, emit) async {
    try {
      emit(FetchingUserData());
      UserModel userData = await profileRepository.changeUserData(event.name);
      emit(UserDataFetched(name: userData.name ?? getRandomUserName()));
    } catch (e) {
      emit(UserDataError());
    }
  }
}
