import 'dart:io';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/list/album_list_screen.dart';
import 'package:ahanghaa/views/list/play_list_screen.dart';
import 'package:ahanghaa/views/list/podcast_list_screen.dart';
import 'package:ahanghaa/views/list/song_list_screen.dart';
import 'package:ahanghaa/views/list/video_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_play_list.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_podcasts_list.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_songs_list.dart';
import 'package:ahanghaa/views/my_widgets/must_watch.dart';
import 'package:ahanghaa/views/my_widgets/top_latest_album.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  BannerAd? _ad;
  bool isAdLoaded = false;
  bool _dispose = true;

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
    _dispose = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      _mainProvider = mainProvider;
      _playerProvider = playerProvider;
      return Scaffold(
        body: SingleChildScrollView(
            child: mainProvider.hasInternet
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Container(
                        height: screenHeight * 0.12,
                        color: MyTheme.instance.colors.secondColorPrimary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) => SongListScreen(
                                            'Musics',
                                            'assets/icons/mini_note.png')));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/mini_note.png',
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Musics',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              width: 1,
                              height: 20,
                              color: MyTheme.instance.colors.colorSecondary,
                            ),
                            InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) => PlayListScreen(
                                            'PlayLists',
                                            'assets/icons/note_2.png')));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/note_2.png',
                                    height: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'PlayLists',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              width: 1,
                              height: 20,
                              color: MyTheme.instance.colors.colorSecondary,
                            ),
                            InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) => PodcastListScreen(
                                            'Podcasts',
                                            'assets/icons/microphone_2.png')));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/microphone_2.png',
                                    height: 22,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Podcasts',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              width: 1,
                              height: 20,
                              color: MyTheme.instance.colors.colorSecondary,
                            ),
                            InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) => VideoListScreen(
                                            'Videos',
                                            'assets/icons/video.png')));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/video.png',
                                    height: 18,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Videos',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              width: 1,
                              height: 20,
                              color: MyTheme.instance.colors.colorSecondary,
                            ),
                            InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) => AlbumListScreen(
                                            'Albums',
                                            'assets/icons/note_frame_1.png')));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/note_frame_1.png',
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Albums',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.08,
                      ),
                      mainProvider.latestMusicList.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: HorizontalSongsList(
                                  musicList: mainProvider.latestMusicList,
                                  iconUrl: 'assets/icons/headset.png',
                                  title: ' Latest Music'),
                            )
                          : Container(
                              height: screenHeight * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                    width: 60,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [
                                        MyTheme.instance.colors.colorSecondary
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      mainProvider.topPadcastsList.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: HorizontalPodcastsList(
                                  podcastsList: mainProvider.topPadcastsList,
                                  iconUrl: 'assets/icons/microphone.png',
                                  title: 'Top Podcasts'),
                            )
                          : Container(
                              height: screenHeight * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                    width: 60,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [
                                        MyTheme.instance.colors.colorSecondary
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: screenWidth = 0.02),
                      if (isAdLoaded)
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          width: _ad!.size.width.toDouble(),
                          height: _ad!.size.height.toDouble(),
                          alignment: Alignment.center,
                          child: AdWidget(
                            ad: _ad!,
                          ),
                        ),
                      mainProvider.playListList.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: HorizontalPlayList(
                                  playList: mainProvider.playListList,
                                  title: 'Latest Playlists',
                                  iconUrl: 'assets/icons/note.png'),
                            )
                          : Container(
                              height: screenHeight * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                    width: 60,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [
                                        MyTheme.instance.colors.colorSecondary
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Visibility(
                        visible: _dispose,
                        child: mainProvider.latestMusicList.length > 0
                            ? TopLatestAlbum(mainProvider.latestAlbumList,
                                'Latest Album', 'assets/icons/note_frame_2.png')
                            : Container(
                                height: screenHeight * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                      width: 60,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.ballBeat,
                                        colors: [
                                          MyTheme.instance.colors.colorSecondary
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.08,
                      ),
                      mainProvider.featuredVideoList.length > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MustWatch(mainProvider.featuredVideoList,
                                    'Latest Video'),
                              ],
                            )
                          : Container(
                              height: screenHeight * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                    width: 60,
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballBeat,
                                      colors: [
                                        MyTheme.instance.colors.colorSecondary
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: screenWidth * 0.15,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.3,
                      ),
                      Icon(
                        Icons.wifi_off_rounded,
                        color: MyTheme.instance.colors.colorSecondary,
                        size: screenHeight * 0.2,
                      ),
                      Center(
                        child: Text(
                          'You are in Offline Mode',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      SizedBox(
                          width: screenWidth * 0.75,
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                              onPressed: () {
                                mainProvider.isInit = false;
                                Phoenix.rebirth(context);
                              },
                              child: Text('Go To Online Mode'))),
                    ],
                  )),
      );
    });
  }

  playMsuic(List<MusicModel> musicList, MusicModel musicModel) {
    if (_playerProvider.currentList.length == 0 ||
        _playerProvider.currentList != musicList ||
        _playerProvider.currentList[_playerProvider.currentMusicIndex].id !=
            musicModel.id) _playerProvider.clearAudio();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: Duration(milliseconds: 500),
            child: PlayerScreen(
                currentList: musicList,
                currentMusicIndex: musicList.indexOf(musicModel))));
  }
}
