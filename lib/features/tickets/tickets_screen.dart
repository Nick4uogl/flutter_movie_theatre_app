import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:movie_theatre_app/%20core/utils/months.dart';
import 'package:movie_theatre_app/features/tickets/widgets/tickets_info.dart';
import 'package:screenshot/screenshot.dart';
import 'package:movie_theatre_app/features/tickets/repositories/ticket_repository.dart';

import 'models/ticket_model.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  late final TicketRepository ticketRepository;
  late Future<List<TicketModel>> tickets;

  @override
  void initState() {
    ticketRepository = TicketRepository();
    tickets = ticketRepository.getTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: const Color(0xff1A2232),
        padding:
            const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 90),
        child: FutureBuilder(
            future: tickets,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const TicketsEmpty();
                } else {
                  List<TicketModel>? tickets = snapshot.data;
                  tickets!.removeWhere((element) => DateTime.now().isAfter(
                      DateTime.fromMillisecondsSinceEpoch(
                          element.date * 1000)));
                  return TicketsBody(tickets: tickets);
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const Center(
                child: SpinKitDualRing(
                  color: Color(0xff637394),
                  lineWidth: 3,
                ),
              );
            }),
      ),
    );
  }
}

class TicketsBody extends StatelessWidget {
  const TicketsBody({Key? key, required this.tickets}) : super(key: key);
  final List<TicketModel> tickets;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CarouselSlider(
        options: CarouselOptions(
          //autoPlay: true,
          height: MediaQuery.of(context).size.height - 100,
          enlargeCenterPage: true,
        ),
        items: List.generate(tickets.length, (index) {
          var date =
              DateTime.fromMillisecondsSinceEpoch(tickets[index].date * 1000);
          var formattedTime = DateFormat.Hm().format(date);
          var day = DateFormat.d().format(date);
          var now = DateTime.now();
          var currentMonth = now.month;
          Widget buildTicket() => MediaQuery(
                data: MediaQueryData(),
                child: Container(
                  width: 375,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff1F293D),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TicketImage(
                        image: tickets[index].image,
                      ),
                      TicketInfo(
                        name: tickets[index].name,
                        date:
                            '$day ${Months.months[currentMonth - 1]}, $formattedTime',
                        roomName: tickets[index].roomName,
                        seat:
                            '${tickets[index].rowIndex} row (${tickets[index].seatIndex})',
                        buildWidget: buildTicket,
                      ),
                      TicketBarCode(
                        ticketId: '${tickets[index].id}',
                      ),
                    ],
                  ),
                ),
              );
          return Container(
            width: 375,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff1F293D),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                TicketImage(
                  image: tickets[index].image,
                ),
                TicketInfo(
                  name: tickets[index].name,
                  date:
                      '$day ${Months.months[currentMonth - 1]}, $formattedTime',
                  roomName: tickets[index].roomName,
                  seat:
                      '${tickets[index].rowIndex} row (${tickets[index].seatIndex})',
                  buildWidget: buildTicket,
                ),
                TicketBarCode(
                  ticketId: '${tickets[index].id}',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class TicketsEmpty extends StatelessWidget {
  const TicketsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/img/icons/popcorn.svg'),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'All your tickets will be here',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xff637394),
            ),
          )
        ],
      ),
    );
  }
}

class TicketBarCode extends StatelessWidget {
  const TicketBarCode({Key? key, required this.ticketId}) : super(key: key);
  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: BarcodeWidget(
        barcode: Barcode.code128(),
        data: ticketId,
        color: Colors.white,
        height: 40,
        drawText: false,
      ),
    );
  }
}

class TicketImage extends StatelessWidget {
  const TicketImage({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              width: 375,
              height: double.infinity,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 0,
            width: (MediaQuery.of(context).size.width > 415)
                ? 375
                : MediaQuery.of(context).size.width - 40,
            child: SvgPicture.asset(
              'assets/img/icons/tearLine.svg',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
