part of 'comments_bloc.dart';

@immutable
abstract class CommentsEvent {}

class AddComment extends CommentsEvent {
  AddComment({required this.id, required this.rating, required this.content});
  final int id;
  final int rating;
  final String content;
}

class LoadComments extends CommentsEvent {
  LoadComments({required this.id});
  final int id;
}

class DeleteComment extends CommentsEvent {
  DeleteComment({required this.id});
  final int id;
}
