import 'dart:io';

import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SongListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';

  SongListScreen(this.title, this.iconUrl);

  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  final PagingController<int, MusicModel> _pagingController =
      PagingController(firstPageKey: 1);
  List<MusicModel> loadedList = [];
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
    _pagingController.addPageRequestListener((pageKey) {
      pageFetch(pageKey);
    });
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (_ad != null) {
      _ad!.dispose();
      isAdLoaded = false;
    }
    _pagingController.dispose();
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
                  text: 'LATEST',
                ),
                Tab(
                  text: 'FEATURED',
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
                  child: PagedListView<int, MusicModel>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<MusicModel>(
                        itemBuilder: (context, item, index) => InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                playMsuic(loadedList, item);
                              },
                              child: VerticalSongItem(item, false, false, 0),
                            ),
                        firstPageProgressIndicatorBuilder: (context) {
                          return MyCircleLoading();
                        },
                        newPageProgressIndicatorBuilder: (context) {
                          return MyCircleLoading();
                        }),
                  )),
              Container(
                color: MyTheme.instance.colors.secondColorPrimary,
                child: ListView(
                  children: mainProvider.mustListenList
                      .map((e) => InkWell(
                          highlightColor: Colors.transparent.withOpacity(0),
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            playMsuic(mainProvider.mustListenList, e);
                          },
                          child: VerticalSongItem(e, false, false, 0)))
                      .toList(),
                ),
              ),
            ]))
          ],
        ),
      );
    });
  }

  Future<void> pageFetch(int offset) async {
    try {
      final newItems =
          await _mainProvider.getLatestMusicListWithPaging(context, offset, 20);
      loadedList.addAll(newItems);
      final isLastPage = newItems.length < 20;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = offset + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
