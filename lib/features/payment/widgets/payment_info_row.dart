import 'package:flutter/material.dart';

class MovieInfoRow extends StatelessWidget {
  const MovieInfoRow({Key? key, required this.title, required this.info})
      : super(key: key);
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 145,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff637394),
            ),
          ),
        ),
        Flexible(
          child: Text(
            info,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
