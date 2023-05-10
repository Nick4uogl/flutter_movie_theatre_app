import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/comments_model.dart';
import '../repositories/comments_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
  }

  CommentsRepository commentsRepository = CommentsRepository();
  List<CommentModel> comments = [];

  void _onAddComment(event, emit) async {
    try {
      emit(AddCommentLoading());
      await commentsRepository.addComment(
          event.id, event.rating, event.content);
      emit(AddCommentLoaded());
    } catch (e) {
      emit(AddCommentError());
    }
  }

  void _onDeleteComment(event, emit) async {
    try {
      emit(CommentsLoading());
      await commentsRepository.deleteComment(event.id);
      emit(CommentDeleted());
    } catch (e) {
      emit(CommentsLoadingError());
    }
  }

  void _onLoadComments(event, emit) async {
    try {
      emit(CommentsLoading());
      comments = await commentsRepository.getComments(event.id);
      emit(CommentsLoaded(comments: comments));
    } catch (e) {
      emit(CommentsLoadingError());
    }
  }
}
