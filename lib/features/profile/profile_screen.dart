import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:movie_theatre_app/features/tickets/repositories/ticket_repository.dart';

import '../../ core/utils/months.dart';
import '../tickets/models/ticket_model.dart';
import 'bloc/user_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(FetchUserData());
  }

  String? name;

  void changeName(value) {
    setState(() {
      name = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        Widget body;
        if (state is FetchingUserData) {
          body = Container(
            color: const Color(0xff1A2232),
            child: const Center(
              child: SpinKitDualRing(
                color: Color(0xff637394),
                lineWidth: 3,
              ),
            ),
          );
        } else if (state is UserDataError) {
          body = Container(
            color: const Color(0xff1A2232),
            child: const Center(
              child: Text(
                'An unexpected error occurred while getting user data',
              ),
            ),
          );
        } else {
          body = Container(
            color: const Color(0xff1A2232),
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                UserNameInput(changeName: changeName, name: name),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  'Payments history',
                  style: TextStyle(
                    color: Color(0xff637394),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const UserPayments(),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xff1F293D),
            centerTitle: true,
            title: Text(
              state.name,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          body: body,
        );
      },
    );
  }
}

class UserPayments extends StatefulWidget {
  const UserPayments({Key? key}) : super(key: key);

  @override
  State<UserPayments> createState() => _UserPaymentsState();
}

class _UserPaymentsState extends State<UserPayments> {
  late final TicketRepository ticketRepository;
  late final Future<List<TicketModel>> tickets;

  @override
  void initState() {
    ticketRepository = TicketRepository();
    tickets = ticketRepository.getTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tickets,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Unable to fetch payments');
        } else if (snapshot.hasData) {
          List<TicketModel> tickets = snapshot.data!;
          if (tickets.isEmpty) return const Text('You have no payments');
          return Column(
            children: List.generate(tickets.length, (index) {
              var date = DateTime.fromMillisecondsSinceEpoch(
                  tickets[index].date * 1000);
              var formattedTime = DateFormat.Hm().format(date);
              var day = DateFormat.d().format(date);
              var now = DateTime.now();
              var currentMonth = now.month;
              return Container(
                margin: index != tickets.length - 1
                    ? const EdgeInsets.only(bottom: 12)
                    : null,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xff1F293D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        tickets[index].smallImage,
                        width: 67,
                        height: 95,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          tickets[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$day ${Months.months[currentMonth - 1]}, $formattedTime',
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          tickets[index].roomName,
                          style: const TextStyle(color: Color(0xff637394)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        }
        return const Center(
          child: SpinKitDualRing(
            color: Color(0xff637394),
            lineWidth: 3,
          ),
        );
      },
    );
  }
}

class UserNameInput extends StatelessWidget {
  const UserNameInput({Key? key, required this.changeName, required this.name})
      : super(key: key);
  final Function changeName;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        changeName(value);
      },
      decoration: InputDecoration(
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 24, minWidth: 50),
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 24, minWidth: 51),
        prefixIcon: SvgPicture.asset(
          'assets/img/icons/profile.svg',
          color: const Color(0xff637394),
          width: 24,
          height: 24,
        ),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff637394))),
        suffixIcon: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            child: InkWell(
              onTap: () {
                if (name != null) {
                  BlocProvider.of<UserBloc>(context)
                      .add(ChangeUserData(name: name!));
                }
              },
              child: Ink(
                height: 24,
                width: 51,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffFF8036),
                      Color(0xffFC6D19),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        hintText: BlocProvider.of<UserBloc>(context).state.name,
        hintStyle: const TextStyle(
          color: Color(0xff637394),
        ),
      ),
    );
  }
}
