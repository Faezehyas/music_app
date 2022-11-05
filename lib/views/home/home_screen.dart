import 'dart:async';
import 'dart:io';
import 'package:ahanghaa/services/notification.dart';
import 'package:ahanghaa/utils/ad_helper.dart';
import 'package:ahanghaa/utils/utils.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uni_links/uni_links.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/album_sliders.dart';
import 'package:ahanghaa/views/my_widgets/for_you_cover.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_play_list.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_songs_list.dart';
import 'package:ahanghaa/views/home/main_slider.dart';
import 'package:ahanghaa/views/my_widgets/must_watch.dart';
import 'package:ahanghaa/views/my_widgets/top_latest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../my_widgets/horizontal_podcasts_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uri? _initialUri;
  Uri? _latestUri;
  StreamSubscription? _sub;
  bool _initialUriIsHandled = false;
  bool isInit = false;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      loadFromNotification(context, message.data);
    });

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
    _sub?.cancel();
    if (_ad != null) {
      _ad!.dispose();
      isAdLoaded = false;
    }
    super.dispose();
  }

  /// while already started.
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      if (uri != null) {
        loadFromDeepLink(context, uri);
      }
    }, onError: (Object err) {
      if (!mounted) return;
    });
  }

  /// Handle the initial Uri - the one the app was started with
  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri != null) {
          loadFromDeepLink(context, uri);
        }
        if (!mounted) return;
      } on PlatformException {}
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      if (!isInit && mainProvider.canLoadDeepLink) {
        isInit = true;
        _handleIncomingLinks();
        _handleInitialUri();
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: mainProvider.hasInternet
              ? Column(
                  children: [
                    /*slider*/ if (mainProvider.slidersList.isNotEmpty)
                      MainSlider(),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    /*must listen*/ mainProvider.mustListenList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: HorizontalSongsList(
                                musicList: mainProvider.mustListenList,
                                iconUrl: 'assets/icons/headset.png',
                                title: 'Must Listen'),
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
                    /*top podcast*/ mainProvider.topPadcastsList.length > 0
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
                    SizedBox(
                      height: screenWidth * 0.02,
                    ),
                    mainProvider.playListList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: HorizontalPlayList(
                                playList: mainProvider.playListList,
                                title: 'Playlists',
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
                    /*for you*/ mainProvider.mustListenList.length > 0
                        ? ForYouCover()
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
                      height: screenHeight * 0.018,
                    ),
                    /*divider*/ Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Container(
                        height: 1,
                        color: MyTheme.instance.colors.colorSecondary,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    /*latest on ahangha*/ mainProvider.latestMusicList.length >
                            0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TopLatest(
                                  mainProvider.latestMusicList,
                                  'Latest on Ahangh‌aa',
                                  'assets/icons/note.png'),
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
                      height: screenHeight * 0.02,
                    ),
                    /*must watch*/ mainProvider.featuredVideoList.length > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MustWatch(
                                  mainProvider.mustWatchList, 'Must Watch'),
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
                      height: screenHeight * 0.015,
                    ),
                    mainProvider.latestAlbumList.length > 0
                        ? AlbumSliders(mainProvider.latestAlbumList)
                        : Container(),
                    SizedBox(
                      height: screenHeight * 0.05,
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
                ),
        ),
      );
    });
  }
}
