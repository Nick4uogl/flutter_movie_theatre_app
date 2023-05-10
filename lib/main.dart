import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_theatre_app/features/bottom_navbar/bloc/bottom_nav_bloc.dart';
import 'package:movie_theatre_app/features/comments/bloc/comments_bloc.dart';
import 'package:movie_theatre_app/features/date/bloc/date_bloc.dart';
import 'package:movie_theatre_app/features/feed/bloc/movies_bloc.dart';
import 'package:movie_theatre_app/features/feed/home_screen.dart';
import 'package:movie_theatre_app/features/profile/bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initialization();
  final prefs = await SharedPreferences.getInstance();
  bool isAuthorized = (prefs.getString('token') != null) ? true : false;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xff1D273A),
  ));

  var bookedSeats = prefs.getStringList('bookedSeats') ?? [];

  for (int i = 0; i < bookedSeats.length; i++) {
    var data = bookedSeats[i].split('-');
    if (DateTime.now().millisecondsSinceEpoch > int.parse(data[1])) {
      bookedSeats.removeAt(i);
    }
  }
  prefs.setStringList('bookedSeats', bookedSeats);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(isAuthorized),
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => BottomNavBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(),
        ),
        BlocProvider<DateBloc>(
          create: (context) => DateBloc(),
        ),
        BlocProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future initialization() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(AuthStart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff637394)),
          ),
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthFailed) {
          return Scaffold(
            body: Center(
              child: Text(state.errorText),
            ),
          );
        }
        if (state.isAuthorized) {
          return const HomePage();
        }
        return const Scaffold(
          backgroundColor: Color(0xff1A2232),
          body: Center(
            child: SpinKitDualRing(
              color: Color(0xff637394),
              lineWidth: 3,
            ),
          ),
        );
      }),
    );
  }
}
