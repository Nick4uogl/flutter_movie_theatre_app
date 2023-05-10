part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {
  CommentsState({this.comments});
  final List<CommentModel>? comments;
}

class CommentsInitial extends CommentsState {
  CommentsInitial() : super(comments: []);
}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  CommentsLoaded({required super.comments});
}

class CommentsLoadingError extends CommentsState {}

class CommentAdded extends CommentsState {}

class CommentDeleted extends CommentsState {}

class AddCommentLoading extends CommentsState {}

class AddCommentLoaded extends CommentsState {}

class AddCommentError extends CommentsState {}
