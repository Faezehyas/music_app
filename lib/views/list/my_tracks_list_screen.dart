import 'dart:io';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyTracksListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';

  MyTracksListScreen(this.title, this.iconUrl);

  @override
  _MyTracksListScreenState createState() => _MyTracksListScreenState();
}

class _MyTracksListScreenState extends State<MyTracksListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  List<MusicModel> savedList = [];
  bool isLoaded = false;
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
    _tabController = TabController(length: 2, vsync: this);
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
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      _mainProvider = mainProvider;
      _playerProvider = playerProvider;
      if (!isLoaded) {
        isLoaded = true;
        mainProvider.getFavoriteList(context).then((value) {
          setState(() {
            savedList = value.musics;
          });
        });
      }
      return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            SizedBox(
              height: screenHeight * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      highlightColor: Colors.transparent.withOpacity(0),
                      splashColor: Colors.transparent.withOpacity(0),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        widget.iconUrl,
                        width: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenWidth * 0.04,
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: MyTheme.instance.colors.colorSecondary,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Downloaded',
                ),
                Tab(
                  text: 'Saved',
                ),
              ],
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
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              Container(
                  color: MyTheme.instance.colors.secondColorPrimary,
                  child: mainProvider.downloadedList.length > 0
                      ? ListView(
                          children: mainProvider.downloadedList
                              .where((element) => !element.isPodcast)
                              .toList()
                              .map((e) => InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () {
                                    playMsuic(
                                        mainProvider.downloadedList
                                            .where(
                                                (element) => !element.isPodcast)
                                            .toList(),
                                        e);
                                  },
                                  child: VerticalSongItem(e, false, true, 0)))
                              .toList(),
                        )
                      : Container()),
              Container(
                  color: MyTheme.instance.colors.secondColorPrimary,
                  child: mainProvider.hasInternet
                      ? savedList.length > 0
                          ? ListView(
                              children: savedList
                                  .where((element) => element.is_favorited!)
                                  .toList()
                                  .map((e) => InkWell(
                                      highlightColor:
                                          Colors.transparent.withOpacity(0),
                                      splashColor:
                                          Colors.transparent.withOpacity(0),
                                      onTap: () {
                                        playMsuic(savedList, e);
                                      },
                                      child:
                                          VerticalSongItem(e, true, false, 0)))
                                  .toList(),
                            )
                          : Container()
                      : Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.1,
                            ),
                            Icon(
                              Icons.wifi_off_rounded,
                              color: MyTheme.instance.colors.colorSecondary,
                              size: screenHeight * 0.2,
                            ),
                            Center(
                              child: Text(
                                'You are in Offline Mode',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
            ]))
          ],
        ),
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
