import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, DataBaseProvider>(
        builder: (context, mainProvider, dataBaseProvider, _) {
      return Container(
        height: screenHeight * 0.08,
        width: double.infinity,
        color: MyTheme.instance.colors.myBalck,
        child: Row(
          children: [
            InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                mainProvider.changeBottomBar(context, BottomBarEnum.Save);
              },
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset('assets/icons/bookmark.png',
                            width: 16,
                            color:
                                mainProvider.bottomBarEnum != BottomBarEnum.Save
                                    ? Colors.grey.shade300
                                    : MyTheme.instance.colors.colorSecondary)),
                    Visibility(
                      visible: mainProvider.bottomBarEnum == BottomBarEnum.Save,
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.8),
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.0)
                                ])),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                mainProvider.changeBottomBar(context, BottomBarEnum.Search);
              },
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                      'assets/icons/search.png',
                      width: 20,
                      color: mainProvider.bottomBarEnum != BottomBarEnum.Search
                          ? Colors.grey.shade300
                          : MyTheme.instance.colors.colorSecondary,
                    )),
                    Visibility(
                      visible:
                          mainProvider.bottomBarEnum == BottomBarEnum.Search,
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.8),
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.0)
                                ])),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                mainProvider.canLoadDeepLink = false;
                mainProvider.changeBottomBar(context, BottomBarEnum.Home);
              },
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                            mainProvider.bottomBarEnum == BottomBarEnum.Home
                                ? 'assets/icons/home.png'
                                : 'assets/icons/home_unselected.png',
                            width: 20,
                            color:
                                mainProvider.bottomBarEnum != BottomBarEnum.Home
                                    ? Colors.grey.shade300
                                    : MyTheme.instance.colors.colorSecondary)),
                    Visibility(
                      visible: mainProvider.bottomBarEnum == BottomBarEnum.Home,
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.8),
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.0)
                                ])),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                mainProvider.changeBottomBar(context, BottomBarEnum.Explore);
              },
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset('assets/icons/note_2.png',
                            width: 20,
                            color: mainProvider.bottomBarEnum !=
                                    BottomBarEnum.Explore
                                ? Colors.grey.shade300
                                : MyTheme.instance.colors.colorSecondary)),
                    Visibility(
                      visible:
                          mainProvider.bottomBarEnum == BottomBarEnum.Explore,
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.8),
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.0)
                                ])),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                mainProvider.changeBottomBar(context, BottomBarEnum.Profile);
              },
              child: SizedBox(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.2,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset('assets/icons/profile.png',
                            width: 17,
                            color: mainProvider.bottomBarEnum !=
                                    BottomBarEnum.Profile
                                ? Colors.grey.shade300
                                : MyTheme.instance.colors.colorSecondary)),
                    Visibility(
                      visible:
                          mainProvider.bottomBarEnum == BottomBarEnum.Profile,
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.8),
                                  MyTheme.instance.colors.colorSecondary
                                      .withOpacity(0.0)
                                ])),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
