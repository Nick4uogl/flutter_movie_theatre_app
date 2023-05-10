part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavEvent {}

class ChangeCurrentTab extends BottomNavEvent {
  ChangeCurrentTab({required this.currentTab});
  final int currentTab;
}
