import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:movie_theatre_app/features/movie_sessions/widgets/sessions_list.dart';

import '../../date/bloc/date_bloc.dart';
import '../models/session_model.dart';
import '../repositories/sessions_repository.dart';

class SessionPageBody extends StatefulWidget {
  const SessionPageBody(
      {Key? key,
      required this.movieName,
      required this.movieImage,
      required this.movieId})
      : super(key: key);
  final String movieName;
  final String movieImage;
  final int movieId;

  @override
  State<SessionPageBody> createState() => _SessionPageBodyState();
}

class _SessionPageBodyState extends State<SessionPageBody> {
  late Future<List<SessionModel>> sessions;
  SessionRepository sessionRepository = SessionRepository();

  @override
  void initState() {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate =
        formatter.format(BlocProvider.of<DateBloc>(context).state.date);
    sessions = sessionRepository.getSessions(widget.movieId, formattedDate);
    super.initState();
  }

  void getTodaySessions(
      List<SessionModel> allSessions, List<SessionModel> todaySessions) {
    for (int i = 0; i < allSessions.length; i++) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(allSessions[i].date * 1000);
      var now = DateTime.now();
      if (date.isAfter(now)) {
        todaySessions.add(allSessions[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sessions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<SessionModel> currentSessions = [];
          getTodaySessions(snapshot.data!, currentSessions);
          currentSessions.sort((a, b) {
            return a.date.compareTo(b.date);
          });
          if (currentSessions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'There are no more sessions for this movie today',
                ),
              ),
            );
          }
          return SessionsList(
            currentSessions: currentSessions,
            movieName: widget.movieName,
            movieImage: widget.movieImage,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
        return Container(
          margin: const EdgeInsets.only(top: 100),
          child: const Center(
            child: SpinKitDualRing(
              color: Color(0xff637394),
              lineWidth: 3,
            ),
          ),
        );
      },
    );
  }
}
