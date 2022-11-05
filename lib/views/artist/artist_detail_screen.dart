import 'dart:io';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/artist/get_artist_detail_respone_model.dart';
import 'package:ahanghaa/models/music/music_details_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_popup.dart';
import 'package:ahanghaa/utils/utils.dart';
import 'package:ahanghaa/views/album/album_detail_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_album_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_song_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_video_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_album_item.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_video_item.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/my_widgets/offcial_tick.dart';
import 'package:ahanghaa/views/my_widgets/top_latest.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:ahanghaa/views/video/mini_screen_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ArtistDetailScreen extends StatefulWidget {
  int artistId = 0;
  ArtistDetailScreen(this.artistId);

  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen>
    with WidgetsBindingObserver {
  GetArtistDetailResponeModel artistDetailModel =
      new GetArtistDetailResponeModel();
  PlayerProvider _playerProvider = new PlayerProvider();
  bool isFisrtLoaded = false;
  bool isLoading = true;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void onDeactivate() {
    isAdLoaded = false;
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.paused == state) {
      isAdLoaded = false;
    }
  }

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
      _playerProvider = playerProvider;
      if (!isFisrtLoaded) {
        isFisrtLoaded = true;
        mainProvider
            .getArtsitDetailListWithPaging(context, widget.artistId, 1, 100)
            .then((value) {
          setState(() {
            isLoading = false;
            artistDetailModel = value;
            MainProvider mainProvider = context.read<MainProvider>();
            if ((Platform.isAndroid &&
                artistDetailModel.artist.admob_id != null)) {
              _ad = BannerAd(
                  size: AdSize.banner,
                  adUnitId: artistDetailModel.artist.admob_id!,
                  listener: BannerAdListener(onAdLoaded: (_) {
                    setState(() {
                      isAdLoaded = true;
                    });
                  }),
                  request: AdRequest());
              _ad!.load();
            } else if ((Platform.isIOS &&
                artistDetailModel.artist.admob_id != null)) {
              _ad = BannerAd(
                  size: AdSize.banner,
                  adUnitId: artistDetailModel.artist.admob_id!,
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
            if (artistDetailModel.podcasts.length > 0) {
              artistDetailModel.musics
                  .addAll(artistDetailModel.podcasts.map((e) {
                e.artist = artistDetailModel.artist;
                return convertPodcastToMusic(e);
              }).toList());
            }
            if (artistDetailModel.musics.length > 0) {
              artistDetailModel.musics.forEach((element) {
                element.artists = new MusicDetailsModel();
                element.artists.singers.add(artistDetailModel.artist);
              });
              artistDetailModel.musics
                  .sort((b, a) => a.visitors.compareTo(b.visitors));
            }
            if (artistDetailModel.albums.length > 0) {
              artistDetailModel.albums.forEach((element) {
                element.artist = artistDetailModel.artist;
              });
            }
            if (artistDetailModel.videos.length > 0) {
              artistDetailModel.videos.forEach((element) {
                element.artists = new MusicDetailsModel();
                element.artists.singers.add(artistDetailModel.artist);
              });
            }
          });
        });
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  isLoading
                      ? SizedBox(
                          height: screenHeight * 0.4, child: MyCircleLoading())
                      : CachedNetworkImage(
                          imageUrl: artistDetailModel.artist.profile_photo,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: screenHeight * 0.4,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  ShareArtistProfilePicker(widget.artistId);
                                },
                                child: Image.asset(
                                  'assets/icons/share.png',
                                  width: 18,
                                ))
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              artistDetailModel.artist.name_en,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            artistDetailModel.artist.is_verified
                                ? SizedBox(height: 10, child: OfficialTick())
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              artistDetailModel.artist.followers.toString(),
                              style: TextStyle(
                                  color:
                                      MyTheme.instance.colors.colorSecondary),
                            ),
                            Text(
                              ' FOLLOWERS',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                        width: screenWidth * 0.27,
                        height: screenHeight * 0.04,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  MyTheme.instance.colors.colorPrimary,
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                            color: MyTheme.instance.colors
                                                .colorSecondary)))),
                            onPressed: () {
                              if (context.read<AuthProvider>().isLogin) {
                                mainProvider.changeArtistFavoriteState(
                                    context, artistDetailModel.artist.id);
                                setState(() {
                                  if (artistDetailModel.artist.is_followed)
                                    artistDetailModel.artist.followers--;
                                  else
                                    artistDetailModel.artist.followers++;
                                  artistDetailModel.artist.is_followed =
                                      !artistDetailModel.artist.is_followed;
                                });
                              } else {
                                showGoToLoginDialog(context, mainProvider);
                              }
                            },
                            child: Text(
                                artistDetailModel.artist.is_followed
                                    ? 'UNFOLLOW'
                                    : 'FOLLOW',
                                style: TextStyle(
                                  color: MyTheme.instance.colors.colorSecondary,
                                  fontSize: 12,
                                ))))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                    size: 14,
                  ),
                  Text(
                    ' ' +
                        artistDetailModel.artist.visitors.toString() +
                        ' Monthly Listeners',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.04,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )),
                          onPressed: () {
                            playMsuic(artistDetailModel.musics,
                                artistDetailModel.musics.first);
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
                              Text('Play all Tracks',
                                  style: TextStyle(
                                    color: MyTheme.instance.colors.colorPrimary,
                                    fontSize: 12,
                                  ))
                            ],
                          )))
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
              artistDetailModel.musics.length > 0
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Top Hits Tracks',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  artistDetailModel.musics.forEach((e) {
                                    e.artists = new MusicDetailsModel();
                                    e.artists.singers
                                        .add(artistDetailModel.artist);
                                  });
                                  Navigator.push(
                                      context,
                                      SwipeablePageRoute(
                                          settings: RouteSettings(name: 'main'),
                                          builder: (context) =>
                                              WithoutTabSongListScreen(
                                                  'Music of ' +
                                                      artistDetailModel
                                                          .artist.display_name,
                                                  artistDetailModel.musics)));
                                },
                                child: Text(
                                  'View All',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        ...(artistDetailModel.musics.length > 3
                                ? artistDetailModel.musics
                                    .getRange(0, 3)
                                    .toList()
                                : artistDetailModel.musics)
                            .map((e) {
                          e.artists = new MusicDetailsModel();
                          e.artists.singers.add(artistDetailModel.artist);
                          return InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                playMsuic(artistDetailModel.musics, e);
                              },
                              child: VerticalSongItem(e, false, false, 0));
                        }).toList(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TopLatest(artistDetailModel.musics, 'Latest', ''),
                          ],
                        )
                      ],
                    )
                  : Container(),
              artistDetailModel.videos.length > 0
                  ? Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Videos',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            artistDetailModel.videos.length > 3
                                ? InkWell(
                                    highlightColor:
                                        Colors.transparent.withOpacity(0),
                                    splashColor:
                                        Colors.transparent.withOpacity(0),
                                    onTap: () {
                                      artistDetailModel.videos.forEach((e) {
                                        e.artists = new MusicDetailsModel();
                                        e.artists.singers
                                            .add(artistDetailModel.artist);
                                      });
                                      Navigator.push(
                                          context,
                                          SwipeablePageRoute(
                                              settings:
                                                  RouteSettings(name: 'main'),
                                              builder: (context) =>
                                                  WithoutTabVideoListScreen(
                                                      'Videos of ' +
                                                          artistDetailModel
                                                              .artist
                                                              .display_name,
                                                      'assets/icons/circle_play.png',
                                                      artistDetailModel
                                                          .videos)));
                                    },
                                    child: Text(
                                      'View All',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: (artistDetailModel.videos.length > 3
                                  ? artistDetailModel.videos
                                      .getRange(0, 3)
                                      .toList()
                                  : artistDetailModel.videos)
                              .map((e) {
                            e.artists = new MusicDetailsModel();
                            e.artists.singers.add(artistDetailModel.artist);
                            return InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  PlayerProvider playerProvider =
                                      new PlayerProvider();
                                  playerProvider.pauseAudio();
                                  Navigator.push(
                                      context,
                                      SwipeablePageRoute(
                                          settings: RouteSettings(name: 'main'),
                                          builder: (context) =>
                                              MiniScreenVideoPlayer(
                                                  artistDetailModel.videos,
                                                  artistDetailModel.videos
                                                      .indexOf(e),
                                                  'Videos of ${artistDetailModel.artist.name_en}',
                                                  'assets/icons/video.png')));
                                },
                                child: HorizontalVideoItem(e));
                          }).toList(),
                        ),
                      )
                    ])
                  : Container(),
              artistDetailModel.albums.length > 0
                  ? Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Albums',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            artistDetailModel.albums.length > 4
                                ? InkWell(
                                    highlightColor:
                                        Colors.transparent.withOpacity(0),
                                    splashColor:
                                        Colors.transparent.withOpacity(0),
                                    onTap: () {
                                      artistDetailModel.albums.forEach((e) {
                                        e.artist = new ArtistModel();
                                        e.artist = artistDetailModel.artist;
                                      });
                                      Navigator.push(
                                          context,
                                          SwipeablePageRoute(
                                              settings:
                                                  RouteSettings(name: 'main'),
                                              builder: (context) =>
                                                  WithoutTabAlbumListScreen(
                                                      'Albums of ' +
                                                          artistDetailModel
                                                              .artist
                                                              .display_name,
                                                      'assets/icons/note_frame_1.png',
                                                      artistDetailModel
                                                          .albums)));
                                    },
                                    child: Text(
                                      'View All',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: (artistDetailModel.albums.length > 4
                                  ? artistDetailModel.albums
                                      .getRange(0, 4)
                                      .toList()
                                  : artistDetailModel.albums)
                              .map((e) {
                            e.artist = artistDetailModel.artist;
                            return InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      SwipeablePageRoute(
                                          settings: RouteSettings(name: 'main'),
                                          builder: (context) =>
                                              AlbumDetailListScreenScreen(e)));
                                },
                                child: HorizontalAlbumItem(e));
                          }).toList(),
                        ),
                      )
                    ])
                  : Container(),
              SizedBox(
                height: 8,
              )
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
