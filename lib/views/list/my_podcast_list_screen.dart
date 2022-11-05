import 'dart:io';

import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/utils.dart';
import 'package:ahanghaa/views/my_widgets/vertical_podcast_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyPodcastListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';

  MyPodcastListScreen(this.title, this.iconUrl);

  @override
  _MyPodcastListScreenState createState() => _MyPodcastListScreenState();
}

class _MyPodcastListScreenState extends State<MyPodcastListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  List<PodcastModel> downloadedPodcasts = [];
  List<PodcastModel> savedList = [];
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
            savedList = value.podcasts;
          });
        });
        downloadedPodcasts = <PodcastModel>[
          ...mainProvider.downloadedList
              .where((element) => element.isPodcast)
              .toList()
              .map((e1) {
            PodcastModel podcastModel = new PodcastModel();
            podcastModel.fromMap(e1.toMap());
            podcastModel.full_url = e1.normal_quality_url;
            podcastModel.artist = new ArtistModel();
            podcastModel.artist = e1.artists.singers.first;
            podcastModel.filePath = e1.filePath;
            podcastModel.imgPath = e1.imgPath;
            return podcastModel;
          }).toList()
        ];
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        widget.iconUrl,
                        height: 18,
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
                  text: 'Saved',
                ),
                Tab(
                  text: 'Downloaded',
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
                child: savedList.length > 0
                    ? ListView(
                        children: savedList
                            .where((element) => element.is_favorited!)
                            .toList()
                            .map((e) => InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  playMusic(savedList, e);
                                },
                                child: VerticalPodcastItem(e, true)))
                            .toList(),
                      )
                    : Container(),
              ),
              Container(
                color: MyTheme.instance.colors.secondColorPrimary,
                child: ListView(
                  children: downloadedPodcasts
                      .map((e) => InkWell(
                          highlightColor: Colors.transparent.withOpacity(0),
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            playMusic(downloadedPodcasts, e);
                          },
                          child: VerticalPodcastItem(e, false)))
                      .toList(),
                ),
              ),
            ]))
          ],
        ),
      );
    });
  }

  playMusic(List<PodcastModel> podcastList, PodcastModel podcastModel) {
    if (_playerProvider.currentList.length == 0 ||
        _playerProvider.currentList[_playerProvider.currentMusicIndex].id !=
            podcastModel.id) _playerProvider.clearAudio();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: Duration(milliseconds: 500),
            child: PlayerScreen(currentList: <MusicModel>[
              ...podcastList.map((e1) {
                return convertPodcastToMusic(e1);
              }).toList()
            ], currentMusicIndex: podcastList.indexOf(podcastModel))));
  }
}
