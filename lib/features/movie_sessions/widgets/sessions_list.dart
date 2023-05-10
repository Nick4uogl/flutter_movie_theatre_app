import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/session_model.dart';
import 'movie_room.dart';

class SessionsList extends StatelessWidget {
  const SessionsList(
      {Key? key,
      required this.currentSessions,
      required this.movieName,
      required this.movieImage})
      : super(key: key);
  final List<SessionModel> currentSessions;
  final String movieName;
  final String movieImage;

  List<int> getPrices(List rows) {
    List<int> prices = [0, 0, 0];
    for (int i = 0; i < rows.length; i++) {
      var seats = rows[i].seats;
      for (int j = 0; j < rows[i].seats.length; j++) {
        if (seats[j].type == 2) {
          prices[0] = seats[j].price;
        }
        if (seats[j].type == 1) {
          prices[1] = seats[j].price;
        }
        if (seats[j].type == 0) {
          prices[2] = seats[j].price;
        }
      }
    }
    return prices;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(currentSessions.length, (index) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            currentSessions[index].date * 1000);
        String formattedTime = DateFormat.Hm().format(date);
        var rows = currentSessions[index].room.rows;
        final prices = getPrices(rows);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MovieRoom(
                  movieName: movieName,
                  image: movieImage,
                  session: currentSessions[index],
                ),
              ),
            ),
            child: Ink(
              height: 56,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: (index != currentSessions.length - 1)
                    ? const Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Color.fromRGBO(109, 158, 255, 0.1),
                        ),
                      )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(109, 158, 255, 0.1),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          formattedTime,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: prices[1] != 0
                        ? Text('${prices[2]} UAH')
                        : const Text('—'),
                  )),
                  Expanded(
                    child: Center(
                      child: prices[1] != 0
                          ? Text('${prices[1]} UAH')
                          : const Text('—'),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: prices[0] != 0
                          ? Text('${prices[0]} UAH')
                          : const Text('—'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
