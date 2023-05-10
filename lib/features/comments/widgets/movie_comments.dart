import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/comments_bloc.dart';
import '../models/comments_model.dart';
import 'comment_button.dart';
import 'movie_comment.dart';

class MovieComments extends StatefulWidget {
  const MovieComments({Key? key, required this.movieId}) : super(key: key);
  final int movieId;

  @override
  State<MovieComments> createState() => _MovieCommentsState();
}

class _MovieCommentsState extends State<MovieComments> {
  @override
  void initState() {
    BlocProvider.of<CommentsBloc>(context)
        .add(LoadComments(id: widget.movieId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(builder: (context, state) {
      if (state is CommentsLoaded) {
        List<CommentModel> commentsList = state.comments!;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          color: Color(0xff192439),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  'Comments',
                  style: TextStyle(color: Color(0xff637394), fontSize: 16),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              if (commentsList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text('Live first comment'),
                )
              else
                Column(
                  children: List.generate(
                    commentsList.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: MovieComment(
                        rating: commentsList[index].rating,
                        commentText: commentsList[index].content,
                        author: commentsList[index].author,
                        isMy: commentsList[index].isMy,
                        id: commentsList[index].id,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 25,
              ),
              CommentsButton(
                movieId: widget.movieId,
              ),
            ],
          ),
        );
      } else if (state is CommentsLoadingError) {
        return Center(
            child: Text('Something went wrong while loading comments'));
      } else if (state is AddCommentLoaded) {
        BlocProvider.of<CommentsBloc>(context)
            .add(LoadComments(id: widget.movieId));
      } else if (state is CommentDeleted) {
        BlocProvider.of<CommentsBloc>(context)
            .add(LoadComments(id: widget.movieId));
      }

      return Center(
        child: SpinKitDualRing(
          color: Color(0xff637394),
          lineWidth: 3,
        ),
      );
    });
  }
}
