import 'dart:io';
import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/my_widgets/vertical_album_item.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../album/album_detail_list_screen.dart';

class AlbumListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';

  AlbumListScreen(this.title, this.iconUrl);

  @override
  _AlbumListScreenState createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  final PagingController<int, AlbumModel> _pagingController =
      PagingController(firstPageKey: 1);
  List<AlbumModel> loadedList = [];
  List<AlbumModel> featuredLoadedList = [];
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
      mainProvider.getFeaturedAlbumList(context).then((value) {
        featuredLoadedList = value;
      });
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
              height: screenHeight * 0.02,
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
                  child: PagedListView<int, AlbumModel>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<AlbumModel>(
                        itemBuilder: (context, item, index) => InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        settings: RouteSettings(name: 'main'),
                                        builder: (context) =>
                                            AlbumDetailListScreenScreen(item)));
                              },
                              child: VerticalAlbumItem(item),
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
                  children: featuredLoadedList
                      .map((e) => InkWell(
                          highlightColor: Colors.transparent.withOpacity(0),
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeablePageRoute(
                                    settings: RouteSettings(name: 'main'),
                                    builder: (context) =>
                                        AlbumDetailListScreenScreen(e)));
                          },
                          child: VerticalAlbumItem(e)))
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
          await _mainProvider.getLatestAlbumListWithPaging(context, offset, 20);
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
}
