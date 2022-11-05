import 'dart:math';

import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ForYouCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      var musicModel =
          mainProvider.mustListenList[mainProvider.forYouCoverRandom];
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/like.png',
                  width: 20,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'For You',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent.withOpacity(0),
            splashColor: Colors.transparent.withOpacity(0),
            onTap: () {
              playerProvider.clearAudio();
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      settings: RouteSettings(name: 'main'),
                      duration: Duration(milliseconds: 500),
                      child: PlayerScreen(
                          currentList: mainProvider.mustListenList,
                          currentMusicIndex: mainProvider.mustListenList
                              .indexOf(musicModel))));
            },
            child: Container(
              height: screenHeight * 0.22,
              width: screenWidth * 0.92,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: musicModel.cover_photo_url!,
                      width: screenWidth * 0.92,
                      height: screenHeight * 0.22,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                            width: 60,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballBeat,
                              colors: [MyTheme.instance.colors.colorSecondary],
                            ),
                          ),
                        ],
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.92,
                    height: screenHeight * 0.22,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 6),
                        Visibility(
                          visible: musicModel.master_quality_url != null &&
                              musicModel.master_quality_url!.isNotEmpty,
                          child: Row(
                            children: [
                              SizedBox(width: 6),
                              Image.asset(
                                'assets/icons/master_star.png',
                                width: 28,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Master',
                                style: TextStyle(
                                    color:
                                        MyTheme.instance.colors.colorSecondary,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: screenHeight * 0.18,
                            width: screenWidth * 0.92,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    MyTheme.data.primaryColor.withOpacity(0.9),
                                    MyTheme.data.primaryColor.withOpacity(0.6),
                                    MyTheme.data.primaryColor.withOpacity(0.4),
                                    MyTheme.data.primaryColor.withOpacity(0.0),
                                  ]),
                            ),
                            child: Column(
                              verticalDirection: VerticalDirection.up,
                              children: [
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    SizedBox(width: 6),
                                    Text(
                                      musicModel.artists.singers.first.name_en,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 6),
                                    Text(
                                        musicModel.title_en!.length > 20
                                            ? musicModel.title_en!
                                                    .substring(0, 20) +
                                                '...'
                                            : musicModel.title_en!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.08,
                                        )),
                                  ],
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
