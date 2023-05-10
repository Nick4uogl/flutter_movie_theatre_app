import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TicketInfo extends StatefulWidget {
  const TicketInfo(
      {Key? key,
      required this.name,
      required this.date,
      required this.roomName,
      required this.seat,
      required this.buildWidget})
      : super(key: key);
  final String name;
  final String date;
  final String roomName;
  final String seat;
  final Function buildWidget;

  @override
  State<TicketInfo> createState() => _TicketInfoState();
}

class _TicketInfoState extends State<TicketInfo> {
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.date,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: 'Hall: ',
                    style: TextStyle(
                      color: Color(0xff637394),
                    ),
                  ),
                  TextSpan(
                    text: widget.roomName,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: 'Seat: ',
                        style: TextStyle(
                          color: Color(0xff637394),
                        ),
                      ),
                      TextSpan(
                        text: widget.seat,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      final controller = ScreenshotController();
                      final bytes = await controller.captureFromWidget(Material(
                        color: Colors.transparent,
                        child: widget.buildWidget(),
                      ));
                      setState(() {
                        imageBytes = bytes;
                      });
                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/image.jpg';
                      File(path).writeAsBytesSync(bytes);
                      await Share.shareFiles([path]);
                    },
                    icon: Icon(Icons.share, color: Color(0xff637394)),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
