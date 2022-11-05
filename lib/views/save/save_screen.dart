import 'dart:io';

import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/views/list/artist_list_screen.dart';
import 'package:ahanghaa/views/list/my_play_list_screen.dart';
import 'package:ahanghaa/views/list/my_podcast_list_screen.dart';
import 'package:ahanghaa/views/list/my_tracks_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_album_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_video_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SaveScreen extends StatefulWidget {
  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  DataBaseProvider _dataBaseProvider = new DataBaseProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  MainProvider _mainProvider = new MainProvider();
  List<MusicModel> recentlyList = [];
  bool isInit = false;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    MainProvider mainProvider = context.read<MainProvider>();
    if (mainProvider.adsModel.admob_android_id.isNotEmpty &&
        mainProvider.adsModel.admob_ios_id.isNotEmpty) {
      _ad = BannerAd(
          size: AdSize.banner,
          adUnitId: Platform.isAndroid
              ? mainProvider.adsModel.admob_android_id
              : mainProvider.adsModel.admob_ios_id,
          listener: BannerAdListener(onAdLoaded: (_) {
            setState(() {
              isAdLoaded = true;
            });
          }),
          request: AdRequest());
      _ad!.load();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_ad != null) {
      _ad!.dispose();
      isAdLoaded = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer3<PlayerProvider, DataBaseProvider, MainProvider>(
        builder: (context, playerProvider, dataBaseProvider, mainProvider, _) {
      if (!isInit) {
        isInit = true;
        mainProvider.getRecentlyPlayed(context).then((value) {
          setState(() {
            recentlyList = value;
          });
        });
      }
      _dataBaseProvider = dataBaseProvider;
      _playerProvider = playerProvider;
      _mainProvider = mainProvider;
      return Scaffold(
        body: SizedBox(
          height: screenHeight * 0.94,
          child: (UserInfos.getToken(context) != null &&
                  UserInfos.getToken(context)!.isNotEmpty)
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    SizedBox(
                      height: screenHeight * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Saved',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            'assets/icons/bookmark.png',
                            width: 14,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                    itemsList(),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    if (isAdLoaded)
                      Container(
                        width: _ad!.size.width.toDouble(),
                        height: _ad!.size.height.toDouble(),
                        alignment: Alignment.center,
                        child: AdWidget(
                          ad: _ad!,
                        ),
                      ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Visibility(
                      visible: recentlyList.length > 0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(children: [
                          Text(
                            'Recently Played',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          )
                        ]),
                      ),
                    ),
                    Visibility(
                      visible: recentlyList.length > 0,
                      child: SizedBox(
                        height: screenHeight * (isAdLoaded ? 0.3 : 0.35),
                        width: screenWidth,
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          childAspectRatio: 0.9,
                          children: (recentlyList.length < 7
                                  ? recentlyList
                                  : recentlyList.getRange(0, 6))
                              .toList()
                              .map((e) {
                            return InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  playMusic(recentlyList, e);
                                },
                                child: HorizontalSongItem(e));
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('You must be logged in to view saved archive',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      SizedBox(
                          width: screenWidth * 0.75,
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                              onPressed: () async {
                                mainProvider.changeBottomBar(
                                    context, BottomBarEnum.Profile);
                              },
                              child: Text('Sign In'))),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  playMusic(List<MusicModel> musicList, MusicModel e) {
    if (_playerProvider.currentList.length == 0 ||
        _playerProvider.currentList != musicList ||
        _playerProvider.currentList[_playerProvider.currentMusicIndex].id !=
            e.id) _playerProvider.clearAudio();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            settings: RouteSettings(name: 'main'),
            duration: Duration(milliseconds: 500),
            child: PlayerScreen(
                currentList: musicList,
                currentMusicIndex: musicList.indexOf(
                    musicList.firstWhere((element) => element.id == e.id!)))));
  }

  Widget itemsList() => Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => MyTracksListScreen(
                                'My Tracks', 'assets/icons/note_frame.png')));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/note_frame.png',
                            width: 16,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'My Tracks',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    _mainProvider.getUserPlayList(context);
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => MyPlayListScreen(
                                'My Playlists', 'assets/icons/play_list.png')));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/play_list.png',
                            width: 16,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'My Playlists',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => WithoutTabAlbumListScreen(
                                'My Albums',
                                'assets/icons/album.png',
                                _mainProvider.favoriteAlbumList)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/album.png',
                            width: 16,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'My Albums',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => MyPodcastListScreen(
                                'My Podcast',
                                'assets/icons/microphone_fill.png')));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/microphone_fill.png',
                            height: 18,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'My Podcasts',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => WithoutTabVideoListScreen(
                                'My Videos',
                                'assets/icons/play_circle_fill.png', [])));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/play_circle_fill.png',
                            width: 16,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'My Vidoes',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) => ArtistListScreen('My Artists',
                                'assets/icons/artist_frame.png', [])));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/artist_frame.png',
                            width: 16,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'My Artists',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      );
}
