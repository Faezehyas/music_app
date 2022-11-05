import 'dart:io';

import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/list/without_tab_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/my_widgets/vertical_album_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_play_list_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/play_list/play_list_detail_screen.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class WithoutTabAlbumListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';
  List<AlbumModel> albumList = [];

  WithoutTabAlbumListScreen(this.title, this.iconUrl, this.albumList);

  @override
  _WithoutTabAlbumListScreenState createState() =>
      _WithoutTabAlbumListScreenState();
}

class _WithoutTabAlbumListScreenState extends State<WithoutTabAlbumListScreen>
    with SingleTickerProviderStateMixin {
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
              ),
            Expanded(
                child: ListView(
              children: widget.albumList
                  .map((e) => InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                      onTap: () {
                        Navigator.push(
                            context,
                            SwipeablePageRoute(
                                builder: (context) => WithoutTabListScreen(
                                    e.title_en, widget.iconUrl, e.id)));
                      },
                      child: VerticalAlbumItem(e)))
                  .toList(),
            ))
          ],
        ),
      );
    });
  }
}
