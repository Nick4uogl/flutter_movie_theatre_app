import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/comments_bloc.dart';

class CommentsButton extends StatefulWidget {
  const CommentsButton({Key? key, required this.movieId}) : super(key: key);
  final int movieId;

  @override
  State<CommentsButton> createState() => _CommentsButtonState();
}

class _CommentsButtonState extends State<CommentsButton> {
  int movieRating = 1;
  String content = '';

  void changeMovieRating(value) {
    setState(() {
      movieRating = value;
    });
  }

  void changeContent(value) {
    setState(() {
      content = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CommentDialog(
                      changeMovieRation: changeMovieRating,
                      changeContent: changeContent,
                      movieRating: movieRating,
                      id: widget.movieId,
                      content: content,
                    );
                  });
            },
            child: Ink(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffFF8036)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Add comment',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffFF8036)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommentDialog extends StatelessWidget {
  const CommentDialog(
      {Key? key,
      required this.changeMovieRation,
      required this.changeContent,
      required this.movieRating,
      required this.id,
      required this.content})
      : super(key: key);
  final Function changeMovieRation;
  final Function changeContent;
  final int movieRating;
  final int id;
  final String content;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Color(0xff1A2435),
          title: const Text('Rate a movie and write a comment'),
          content: (state is AddCommentLoading)
              ? Center(
                  child: SpinKitDualRing(
                    color: Color(0xff637394),
                    lineWidth: 3,
                  ),
                )
              : (state is AddCommentError)
                  ? Text('Error while adding comment')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          itemSize: 35,
                          initialRating: 1,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            changeMovieRation(rating.round());
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          maxLines: 8,
                          onChanged: (value) {
                            changeContent(value);
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(99, 115, 148, 0.6),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            fillColor:
                                const Color.fromRGBO(118, 118, 128, 0.12),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Your comment',
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(99, 115, 148, 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Disable',
                style: TextStyle(
                  color: Color(0xff637394),
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Publish',
                style: TextStyle(
                  color: Color(0xffFC6D19),
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                BlocProvider.of<CommentsBloc>(context).add(
                  AddComment(
                    id: id,
                    rating: movieRating,
                    content: content,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
