import 'dart:io';

import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/my_widgets/circle_artist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ArtistListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';
  List<ArtistModel> artistList = [];

  ArtistListScreen(this.title, this.iconUrl, this.artistList);

  @override
  _ArtistListScreenState createState() => _ArtistListScreenState();
}

class _ArtistListScreenState extends State<ArtistListScreen> {
  MainProvider _mainProvider = new MainProvider();
  List<ArtistModel> loadedList = [];
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
      if (mainProvider.hasInternet &&
          !isLoaded &&
          widget.artistList.length == 0) {
        isLoaded = true;
        mainProvider.getFavoriteArtistList(context).then((value) {
          setState(() {
            loadedList = value;
          });
        });
      }
      return Scaffold(
        backgroundColor: MyTheme.instance.colors.secondColorPrimary,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Divider(
                color: Colors.grey,
                height: 1,
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
              child: mainProvider.hasInternet
                  ? GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(
                          (widget.artistList.length > 0
                                  ? widget.artistList
                                  : loadedList)
                              .length, (index) {
                        return InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) =>ArtistDetailScreen(
                                          (widget.artistList.length > 0
                                                  ? widget.artistList
                                                  : loadedList)[index]
                                              .id)));
                              
                            },
                            child: CircleArtistItem(
                                (widget.artistList.length > 0
                                    ? widget.artistList
                                    : loadedList)[index]));
                      }),
                    )
                  : Column(
                      children: [
                        Column(
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
                        )
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}
