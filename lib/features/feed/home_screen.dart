import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_theatre_app/features/bottom_navbar/bloc/bottom_nav_bloc.dart';
import 'package:movie_theatre_app/features/date/bloc/date_bloc.dart';
import 'package:movie_theatre_app/features/feed/bloc/movies_bloc.dart';
import 'package:movie_theatre_app/features/feed/widgets/movie_about.dart';
import 'package:movie_theatre_app/features/feed/widgets/mybottom_navbar.dart';
import 'package:movie_theatre_app/features/feed/widgets/search.dart';
import 'package:movie_theatre_app/features/profile/profile_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../tickets/tickets_screen.dart';
import 'models/movie_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const HomePageBody(),
    const TicketsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body:
          BlocBuilder<BottomNavBloc, BottomNavState>(builder: (context, state) {
        return pages[state.currentTab];
      }),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    DateTime date = BlocProvider.of<DateBloc>(context).state.date;
    String formattedDate = formatter.format(date);
    BlocProvider.of<MoviesBloc>(context).add(LoadMovies(date: formattedDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: MovieHomeAppBar(),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
        color: const Color(0xff1A2232),
        child: const MovieHomeContent(),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 70),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff21232F),
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: BlocProvider.of<DateBloc>(context).state.date,
              firstDate: DateTime.now(),
              lastDate: DateTime(2024, 1, 0),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xff1A2435),
                      onPrimary: Color(0xffFC6D19),
                      onSurface: Color(0xff637394),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        primary: const Color(0xffFC6D19), // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedDate == null) return;
            String formattedDate = formatter.format(selectedDate);

            if (context.mounted) {
              BlocProvider.of<DateBloc>(context)
                  .add(ChangeDate(date: selectedDate));
              BlocProvider.of<MoviesBloc>(context)
                  .add(LoadMovies(date: formattedDate));
            }
          },
          child: const Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class MovieHomeContent extends StatelessWidget {
  const MovieHomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is MoviesLoaded || state is MoviesSearched) {
          if (state.movies!.isEmpty && state is MoviesLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('img/icons/popcorn.svg'),
                const SizedBox(
                  height: 12,
                ),
                const Center(
                  child: Text(
                    'For this day is no movies in the cinema',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          }

          Widget movies;
          if (state is MoviesSearching) {
            movies = const SpinKitDualRing(
              color: Color(0xff637394),
              lineWidth: 3,
            );
          } else if (state is MoviesSearchError) {
            movies = const Center(
              child: Text(
                'Can`t search movies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          } else if (state.movies!.isEmpty) {
            movies = const Text(
              'No movies for your input',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red),
            );
          } else {
            movies = MoviesList(
              movies: state.movies!,
            );
          }
          return ListView(
            children: [
              const SearchMovie(),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Now in cinema',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              movies,
              const SizedBox(
                height: 20,
              ),
            ],
          );
        } else if (state is MoviesError) {
          return const Center(
            child: Text('Occured unexpected error while fetching movies'),
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

class MovieHomeAppBar extends StatelessWidget {
  const MovieHomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: const Color(0xff1D273A),
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Image.asset(
              "assets/img/logo.png",
              width: 52,
              height: 52,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Lavina IMAX Laser',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoviesList extends StatelessWidget {
  const MoviesList({super.key, required this.movies});
  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 163 / 260,
      shrinkWrap: true,
      crossAxisCount: (movies.length == 1) ? 1 : 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        movies.length,
        (index) {
          return MoviePoster(
            movie: movies[index],
          );
        },
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  const MoviePoster({super.key, required this.movie});
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MovieAbout(movie: movie)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 31,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF8036),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        movie.rating.substring(0, movie.rating.length - 1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            movie.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            movie.genre,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff637394),
            ),
          ),
        ],
      ),
    );
  }
}
