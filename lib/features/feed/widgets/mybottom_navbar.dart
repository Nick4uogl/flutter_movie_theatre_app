import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bottom_navbar/bloc/bottom_nav_bloc.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
        child: Container(
          //color: Color.fromRGBO(31, 41, 61, 0.6),
          color: Colors.transparent,
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<BottomNavBloc>(context)
                          .add(ChangeCurrentTab(currentTab: 0));
                    },
                    icon: (state.currentTab == 0)
                        ? SvgPicture.asset(
                            'assets/img/icons/Home.svg',
                            width: 27,
                            height: 27,
                            color: const Color(0xffFF8036),
                          )
                        : SvgPicture.asset(
                            'assets/img/icons/Home.svg',
                            width: 27,
                            height: 27,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<BottomNavBloc>(context)
                          .add(ChangeCurrentTab(currentTab: 1));
                    },
                    icon: (state.currentTab == 1)
                        ? SvgPicture.asset(
                            'assets/img/icons/ticket.svg',
                            width: 27,
                            height: 27,
                            color: const Color(0xffFF8036),
                          )
                        : SvgPicture.asset(
                            'assets/img/icons/ticket.svg',
                            width: 27,
                            height: 27,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<BottomNavBloc>(context)
                          .add(ChangeCurrentTab(currentTab: 2));
                    },
                    icon: (state.currentTab == 2)
                        ? SvgPicture.asset(
                            'assets/img/icons/profile.svg',
                            width: 27,
                            height: 27,
                            color: const Color(0xffFF8036),
                          )
                        : SvgPicture.asset(
                            'assets/img/icons/profile.svg',
                            width: 27,
                            height: 27,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
