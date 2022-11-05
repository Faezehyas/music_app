import 'dart:io';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
            height: screenHeight * 0.074,
            width: double.infinity,
            child: Stack(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            settings: RouteSettings(name: 'main'),
                            duration: Duration(milliseconds: 500),
                            child: PlayerScreen(
                                currentList: playerProvider.currentList,
                                currentMusicIndex:
                                    playerProvider.currentMusicIndex)));
                  },
                  child: Column(
                    verticalDirection: VerticalDirection.up,
                    children: [
                      Container(
                        height: screenHeight * 0.07,
                        color: MyTheme.instance.colors.colorSecondary3,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 0, 4),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          child: playerProvider
                                                      .currentList[playerProvider
                                                          .currentMusicIndex]
                                                      .imgPath ==
                                                  null
                                              ? Image.network(
                                                  playerProvider
                                                      .currentList[playerProvider
                                                          .currentMusicIndex]
                                                      .cover_photo_url!,
                                                  width: screenHeight * 0.06,
                                                  height: screenHeight * 0.06,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  new File(playerProvider
                                                      .currentList[playerProvider
                                                          .currentMusicIndex]
                                                      .imgPath!),
                                                  width: screenHeight * 0.06,
                                                  height: screenHeight * 0.06,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Column(
                                          verticalDirection:
                                              VerticalDirection.up,
                                          children: [
                                            Container(
                                              width: screenWidth * 0.5,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    (playerProvider
                                                                .currentList[
                                                                    playerProvider
                                                                        .currentMusicIndex]
                                                                .title_en!
                                                                .length >
                                                            20
                                                        ? playerProvider
                                                                .currentList[
                                                                    playerProvider
                                                                        .currentMusicIndex]
                                                                .title_en!
                                                                .substring(
                                                                    0, 20) +
                                                            '...'
                                                        : playerProvider
                                                            .currentList[
                                                                playerProvider
                                                                    .currentMusicIndex]
                                                            .title_en!),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Container(
                                              width: screenWidth * 0.5,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    playerProvider
                                                        .currentList[playerProvider
                                                            .currentMusicIndex]
                                                        .artists
                                                        .singers
                                                        .first
                                                        .name_en,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (playerProvider
                                              .playerState.playing)
                                            playerProvider.pauseAudio();
                                          else
                                            playerProvider.playAudio();
                                        },
                                        icon: Image.asset(
                                          playerProvider.playerState.playing
                                              ? 'assets/icons/mini_pause.png'
                                              : 'assets/icons/mini_play.png',
                                          height: screenHeight * 0.022,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (playerProvider
                                              .currentList[playerProvider
                                                  .currentMusicIndex]
                                              .isPodcast)
                                            mainProvider
                                                .changePodcastFavoriteState(
                                                    context,
                                                    playerProvider
                                                        .currentList[playerProvider
                                                            .currentMusicIndex]
                                                        .id!);
                                          else
                                            mainProvider.changeFavoriteState(
                                                context,
                                                playerProvider
                                                    .currentList[playerProvider
                                                        .currentMusicIndex]
                                                    .id!);
                                          setState(() {
                                            playerProvider
                                                .currentList[playerProvider
                                                    .currentMusicIndex]
                                                .is_favorited = !(playerProvider
                                                    .currentList[playerProvider
                                                        .currentMusicIndex]
                                                    .is_favorited ??
                                                false);
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/icons/bookmark.png',
                                          height: screenHeight * 0.022,
                                          color: (playerProvider
                                                      .currentList[playerProvider
                                                          .currentMusicIndex]
                                                      .is_favorited ??
                                                  false)
                                              ? MyTheme.instance.colors
                                                  .colorSecondary
                                              : Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.018,
                                    ),
                                    Text(
                                      playerProvider.currentDurationStr,
                                      style: TextStyle(
                                          color: MyTheme
                                              .instance.colors.colorSecondary,
                                          fontSize: 10),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ProgressBar(
                      progress: playerProvider.currentDuration,
                      buffered: playerProvider.totalDuration,
                      total: playerProvider.totalDuration,
                      progressBarColor: MyTheme.instance.colors.colorSecondary,
                      baseBarColor: Colors.white.withOpacity(0.24),
                      bufferedBarColor: MyTheme.instance.colors.colorSecondary2,
                      timeLabelLocation: TimeLabelLocation.none,
                      thumbColor:
                          MyTheme.instance.colors.colorSecondary.withOpacity(0),
                      barHeight: 4.0,
                      thumbRadius: 5.0,
                      onSeek: (duration) {
                        playerProvider.seekAudio(duration);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
