import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/comments_bloc.dart';

class MovieComment extends StatelessWidget {
  const MovieComment(
      {Key? key,
      required this.commentText,
      required this.author,
      required this.rating,
      required this.isMy,
      required this.id})
      : super(key: key);
  final String? commentText;
  final String? author;
  final int? rating;
  final int id;
  final bool isMy;

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    stars += List.generate(
      rating!,
      (index) => Padding(
        padding: EdgeInsets.only(left: 6),
        child: Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
      ),
    );
    stars += List.generate(
      5 - rating!,
      (index) => Icon(
        Icons.star_border_outlined,
        color: Colors.amber,
        size: 15,
      ),
    );

    return Container(
      padding: EdgeInsets.only(bottom: 13, left: 18, right: 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(109, 158, 255, 0.1),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: (author == null)
                          ? Text(
                              'N/A',
                              style: TextStyle(fontSize: 16),
                            )
                          : Text(
                              author!,
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    Row(children: stars),
                  ],
                ),
                if (commentText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Text(
                      commentText!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          if (isMy)
            IconButton(
              icon: SvgPicture.asset('assets/img/icons/delete.svg'),
              onPressed: () {
                BlocProvider.of<CommentsBloc>(context)
                    .add(DeleteComment(id: id));
              },
            )
        ],
      ),
    );
  }
}
