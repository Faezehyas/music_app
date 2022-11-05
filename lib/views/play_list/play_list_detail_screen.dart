import 'dart:io';
import 'dart:math';

import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/views/my_widgets/show_blur_bottom_sheet.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

enum sortOrderEnum { NONE, ARTIST, DATEADDED, ALPHABETICAL, CUSTOMORDER }

class PlayListDetailScreen extends StatefulWidget {
  PlayListModel playListModel = new PlayListModel();
  bool isMyPlayList = false;
  PlayListDetailScreen(this.playListModel, this.isMyPlayList);

  @override
  _PlayListDetailScreenState createState() => _PlayListDetailScreenState();
}

class _PlayListDetailScreenState extends State<PlayListDetailScreen> {
  List<MusicModel> loadedPlayListMusic = [];
  PlayerProvider _playerProvider = new PlayerProvider();
  bool isLoaded = false;
  sortOrderEnum _sortOrderEnum = sortOrderEnum.NONE;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    MainProvider mainProvider = context.read<MainProvider>();
    if (widget.playListModel.admob_id != null ||
        (mainProvider.adsModel.admob_android_id.isNotEmpty &&
            mainProvider.adsModel.admob_ios_id.isNotEmpty)) {
      _ad = BannerAd(
          size: AdSize.banner,
          adUnitId: widget.playListModel.admob_id ??
              (Platform.isAndroid
                  ? mainProvider.adsModel.admob_android_id
                  : mainProvider.adsModel.admob_ios_id),
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
      _playerProvider = playerProvider;
      if (!isLoaded) {
        isLoaded = true;
        if (widget.isMyPlayList) {
          mainProvider
              .getUserPlayListById(context, widget.playListModel.id)
              .then((value) {
            setState(() {
              loadedPlayListMusic = value.musics;
            });
          });
        } else {
          mainProvider
              .getPlayListById(context, widget.playListModel.id)
              .then((value) {
            setState(() {
              loadedPlayListMusic = value.musics;
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
                    imageUrl: widget.playListModel.cover_photo,
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
                      SizedBox(
                        height: screenHeight * 0.06,
                        child: Row(
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
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 32),
                                        child: InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () => showOptionMenu(context),
                                          child: Image.asset(
                                            'assets/icons/sort.png',
                                            width: 24,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            widget.playListModel.name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            widget.playListModel.visitors
                                                    .toString() +
                                                ' Playes',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )
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
                            playMsuic(
                                loadedPlayListMusic, loadedPlayListMusic.first);
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
                                loadedPlayListMusic,
                                loadedPlayListMusic[new Random()
                                    .nextInt(loadedPlayListMusic.length)]);
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
                                if (widget.isMyPlayList)
                                  ShareUserPlayListPicker(
                                      context, widget.playListModel);
                                else
                                  SharePlayListPicker(
                                      context, widget.playListModel);
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
                              mainProvider.changePlayListFavoriteState(
                                  context, widget.playListModel);
                              setState(() {
                                widget.playListModel.is_favorited =
                                    !widget.playListModel.is_favorited;
                              });
                            },
                            child: Image.asset(
                              'assets/icons/bookmark2.png',
                              color: (widget.playListModel.is_favorited)
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
              SizedBox(
                height: screenHeight * 0.02,
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
              ...loadedPlayListMusic.map((e) {
                return InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      playMsuic(loadedPlayListMusic, e);
                    },
                    child: VerticalSongItem(e, false, false,
                        widget.isMyPlayList ? widget.playListModel.id : 0));
              }).toList()
            ],
          ),
        ),
      );
    });
  }

  void showOptionMenu(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    showBlurBottomSheet(context,
        StatefulBuilder(builder: (thisLowerContext, innerSetState) {
      return Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
        return Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 8),
                width: screenWidth * 0.3,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: InkWell(
            // highlightColor: Colors.transparent.withOpacity(0),
            // splashColor: Colors.transparent.withOpacity(0),
            //     onTap: () {},
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/account.png',
            //           width: 20,
            //           color: Colors.white,
            //         ),
            //         SizedBox(
            //           width: 24,
            //         ),
            //         Text(
            //           'Custom order',
            //           style: TextStyle(
            //               color: Colors.white, fontWeight: FontWeight.bold),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  if (_sortOrderEnum != sortOrderEnum.ALPHABETICAL) {
                    setState(() {
                      loadedPlayListMusic.sort((a, b) {
                        return a.title_en!
                            .toLowerCase()
                            .compareTo(b.title_en!.toLowerCase());
                      });
                      _sortOrderEnum = sortOrderEnum.ALPHABETICAL;
                    });
                  } else {
                    setState(() {
                      context
                          .read<MainProvider>()
                          .getUserPlayListById(context, widget.playListModel.id)
                          .then((value) {
                        setState(() {
                          loadedPlayListMusic = value.musics;
                        });
                      });
                      _sortOrderEnum = sortOrderEnum.NONE;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/sort_a_to_z.png',
                      width: 20,
                      color: _sortOrderEnum == sortOrderEnum.ALPHABETICAL
                          ? MyTheme.instance.colors.colorSecondary
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Alphabetical',
                      style: TextStyle(
                          color: _sortOrderEnum == sortOrderEnum.ALPHABETICAL
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  if (_sortOrderEnum != sortOrderEnum.DATEADDED) {
                    setState(() {
                      loadedPlayListMusic.sort((b, a) {
                        return a.id!.compareTo(b.id!);
                      });
                      _sortOrderEnum = sortOrderEnum.DATEADDED;
                    });
                  } else {
                    setState(() {
                      context
                          .read<MainProvider>()
                          .getUserPlayListById(context, widget.playListModel.id)
                          .then((value) {
                        setState(() {
                          loadedPlayListMusic = value.musics;
                        });
                      });
                      _sortOrderEnum = sortOrderEnum.NONE;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/date.png',
                      width: 20,
                      color: _sortOrderEnum == sortOrderEnum.DATEADDED
                          ? MyTheme.instance.colors.colorSecondary
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Date added',
                      style: TextStyle(
                          color: _sortOrderEnum == sortOrderEnum.DATEADDED
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  if (_sortOrderEnum != sortOrderEnum.ARTIST) {
                    setState(() {
                      loadedPlayListMusic.sort((a, b) {
                        return a.artists.singers.first.name_en
                            .compareTo(b.artists.singers.first.name_en);
                      });
                      _sortOrderEnum = sortOrderEnum.ARTIST;
                    });
                  } else {
                    setState(() {
                      context
                          .read<MainProvider>()
                          .getUserPlayListById(context, widget.playListModel.id)
                          .then((value) {
                        setState(() {
                          loadedPlayListMusic = value.musics;
                        });
                      });
                      _sortOrderEnum = sortOrderEnum.NONE;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/microphone_1.png',
                      width: 20,
                      color: _sortOrderEnum == sortOrderEnum.ARTIST
                          ? MyTheme.instance.colors.colorSecondary
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Artist',
                      style: TextStyle(
                          color: _sortOrderEnum == sortOrderEnum.ARTIST
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/sort.png',
                    width: 24,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    'Sorting',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        );
      });
    }), () {});
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
            settings: RouteSettings(name: 'main'),
            duration: Duration(milliseconds: 500),
            child: PlayerScreen(
                currentList: musicList,
                currentMusicIndex: musicList.indexOf(musicModel))));
  }
}
