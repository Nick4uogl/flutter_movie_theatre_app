part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavState {
  const BottomNavState({this.currentTab = 0});
  final int currentTab;
}

class BottomNavInitial extends BottomNavState {
  const BottomNavInitial({super.currentTab = 0});
}

class CurrentTabChanged extends BottomNavState {
  const CurrentTabChanged({super.currentTab});
}
