import 'dart:io';

import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_top_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class TopChartsSongListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';

  TopChartsSongListScreen(this.title, this.iconUrl);

  @override
  _TopChartsSongListScreenState createState() =>
      _TopChartsSongListScreenState();
}

class _TopChartsSongListScreenState extends State<TopChartsSongListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
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
    _tabController = TabController(length: 4, vsync: this);
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        widget.iconUrl,
                        width: 18,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
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
              )
            else
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
                  text: 'Today',
                ),
                Tab(
                  text: 'Week',
                ),
                Tab(
                  text: 'Month',
                ),
                Tab(
                  text: 'Year',
                ),
              ],
            ),
            mainProvider.hasInternet
                ? Expanded(
                    child: TabBarView(controller: _tabController, children: [
                    Container(
                      color: MyTheme.instance.colors.secondColorPrimary,
                      child: ListView(
                        children: mainProvider.topTracksDayList
                            .map((e) => InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  playMsuic(mainProvider.topTracksDayList, e);
                                },
                                child: VerticalTopSongItem(
                                    e,
                                    mainProvider.topTracksDayList.indexOf(e) +
                                        1)))
                            .toList(),
                      ),
                    ),
                    Container(
                      color: MyTheme.instance.colors.secondColorPrimary,
                      child: ListView(
                        children: mainProvider.topTracksWeekList
                            .map((e) => InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  playMsuic(mainProvider.topTracksWeekList, e);
                                },
                                child: VerticalTopSongItem(
                                    e,
                                    mainProvider.topTracksWeekList.indexOf(e) +
                                        1)))
                            .toList(),
                      ),
                    ),
                    Container(
                      color: MyTheme.instance.colors.secondColorPrimary,
                      child: ListView(
                        children: mainProvider.topTracksMonthList
                            .map((e) => InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  playMsuic(mainProvider.topTracksMonthList, e);
                                },
                                child: VerticalTopSongItem(
                                    e,
                                    mainProvider.topTracksMonthList.indexOf(e) +
                                        1)))
                            .toList(),
                      ),
                    ),
                    Container(
                      color: MyTheme.instance.colors.secondColorPrimary,
                      child: ListView(
                        children: mainProvider.topTracksYearList
                            .map((e) => InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  playMsuic(mainProvider.topTracksYearList, e);
                                },
                                child: VerticalTopSongItem(
                                    e,
                                    mainProvider.topTracksYearList.indexOf(e) +
                                        1)))
                            .toList(),
                      ),
                    ),
                  ]))
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
                  )
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
