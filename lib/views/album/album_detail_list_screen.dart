import 'dart:io';
import 'dart:math';
import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/views/my_widgets/vertical_album_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AlbumDetailListScreenScreen extends StatefulWidget {
  AlbumModel albumModel;

  AlbumDetailListScreenScreen(this.albumModel);

  @override
  _AlbumDetailListScreenScreenState createState() =>
      _AlbumDetailListScreenScreenState();
}

class _AlbumDetailListScreenScreenState
    extends State<AlbumDetailListScreenScreen> {
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  List<MusicModel> loadedList = [];
  List<MusicModel> musicList = [];
  bool isLoaded = false;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    MainProvider mainProvider = context.read<MainProvider>();
    if (widget.albumModel.admob_id != null ||
        widget.albumModel.artist.admob_id != null) {
      _ad = BannerAd(
          size: AdSize.banner,
          adUnitId:
              widget.albumModel.admob_id ?? widget.albumModel.artist.admob_id!,
          listener: BannerAdListener(onAdLoaded: (_) {
            setState(() {
              isAdLoaded = true;
            });
          }),
          request: AdRequest());
      _ad!.load();
    } else if ((mainProvider.adsModel.admob_android_id.isNotEmpty &&
        mainProvider.adsModel.admob_ios_id.isNotEmpty)) {
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
      if (!isLoaded) {
        isLoaded = true;

        if (widget.albumModel.id > 0) {
          mainProvider
              .getAlbumsMusicList(context, widget.albumModel.id)
              .then((value) {
            setState(() {
              musicList = value;
            });
          });
        }
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.albumModel.cover_photo_url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: screenHeight * 0.4,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: Column(
                      verticalDirection: VerticalDirection.up,
                      children: [
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  MyTheme.data.primaryColor,
                                  MyTheme.data.primaryColor.withOpacity(0.2),
                                  MyTheme.data.primaryColor.withOpacity(0.0)
                                ]),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        widget.albumModel.artist.display_name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        widget.albumModel.title_en,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.04,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              )),
                          onPressed: () {
                            playMsuic(musicList, musicList.first);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/play_solid.png',
                                width: 18,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Play',
                                  style: TextStyle(
                                    color: MyTheme.instance.colors.colorPrimary,
                                    fontSize: 12,
                                  ))
                            ],
                          ))),
                  SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.04,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )),
                          onPressed: () {
                            playMsuic(
                                musicList,
                                musicList[
                                    new Random().nextInt(musicList.length)]);
                            playerProvider.setShuffleModel();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/shuffle.png',
                                width: 18,
                                color: MyTheme.instance.colors.colorPrimary,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Shuffle',
                                  style: TextStyle(
                                    color: MyTheme.instance.colors.colorPrimary,
                                    fontSize: 12,
                                  ))
                            ],
                          )))
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.3,
                    height: 30,
                    decoration: BoxDecoration(
                        color: MyTheme.instance.colors.myBalck2,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                ShareAlbumPicker(context, widget.albumModel);
                              },
                              child: Image.asset(
                                'assets/icons/share.png',
                                color: Colors.grey,
                                width: 16,
                              )),
                          InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              mainProvider.changeAlbumFavoriteState(
                                  context, widget.albumModel);
                              setState(() {
                                widget.albumModel.is_favorited =
                                    !widget.albumModel.is_favorited;
                              });
                            },
                            child: Image.asset(
                              'assets/icons/bookmark2.png',
                              color: (widget.albumModel.is_favorited)
                                  ? MyTheme.instance.colors.colorSecondary
                                  : Colors.grey,
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (isAdLoaded)
                Container(
                  margin: EdgeInsets.only(top: 8),
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
              mainProvider.hasInternet
                  ? Column(
                      children: musicList.length > 0
                          ? musicList.map((e) {
                              return InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () {
                                    playMsuic(musicList, e);
                                  },
                                  child: VerticalAlbumSongItem(
                                      e, musicList.indexOf(e) + 1));
                            }).toList()
                          : [],
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
            ],
          ),
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
