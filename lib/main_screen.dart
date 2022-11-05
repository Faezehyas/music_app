import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/views/auth/auth_tab_screen.dart';
import 'package:ahanghaa/views/explore/explore_screen.dart';
import 'package:ahanghaa/views/home/home_screen.dart';
import 'package:ahanghaa/views/my_widgets/bottom_bar.dart';
import 'package:ahanghaa/views/save/save_screen.dart';
import 'package:ahanghaa/views/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/my_widgets/mini_player.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      SaveScreen(),
      SearchScreen(),
      HomeScreen(),
      ExploreScreen(),
      AuthTabScreen()
    ];
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return Scaffold(
        body: Stack(
          children: [
            screens[selectBottomBarfromEnum(mainProvider.bottomBarEnum)],
            playerProvider.isLoaded ? MiniPlayer() : Container()
          ],
        ),
        bottomNavigationBar: BottomBar(),
      );
    });
  }
}
