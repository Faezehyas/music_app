import 'dart:io';
import 'package:ahanghaa/models/enums/timer_enum.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/music/music_quality_enum.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/show_popup.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/clip_creator/create_clip_screen.dart';
import 'package:ahanghaa/views/list/without_tab_song_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/bottom_bar.dart';
import 'package:ahanghaa/views/my_widgets/offcial_tick.dart';
import 'package:ahanghaa/views/my_widgets/show_blur_bottom_sheet.dart';
import 'package:ahanghaa/views/play_list/add_to_play_list_screen.dart';
import 'package:ahanghaa/views/player/cheromecast_screen.dart';
import 'package:ahanghaa/views/player/player_blur_background.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class PlayerScreen extends StatefulWidget {
  List<MusicModel> currentList = [];
  int currentMusicIndex = 0;

  PlayerScreen({required this.currentList, required this.currentMusicIndex});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  bool isQualityDropDownOpen = false;
  late AnimationController _controller;
  PlayerProvider _playerProvider = new PlayerProvider();
  MainProvider _mainProvider = new MainProvider();
  AuthProvider _authProvider = new AuthProvider();
  Animation<double>? animation;
  bool isBottomSheetLoaded = false;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    MainProvider mainProvider = context.read<MainProvider>();
    if (widget.currentList[widget.currentMusicIndex].admob_id != null ||
        widget.currentList[widget.currentMusicIndex].artists.singers.first
                .admob_id !=
            null) {
      _ad = BannerAd(
          size: AdSize.banner,
          adUnitId: widget.currentList[widget.currentMusicIndex].admob_id ??
              widget.currentList[widget.currentMusicIndex].artists.singers.first
                  .admob_id!,
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

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
    return Dismissible(
      key: Key(UniqueKey().toString()),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: Consumer3<MainProvider, PlayerProvider, AuthProvider>(
          builder: (context, mainProvider, playerProvider, authProvider, _) {
        playerProvider.initPlayer(
            context, widget.currentList, widget.currentMusicIndex);
        _playerProvider = playerProvider;
        _mainProvider = mainProvider;
        _authProvider = authProvider;
        return Scaffold(
            body: Column(
          children: [
            Container(
              height: screenHeight * 0.92,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              /*blur img*/ PlayerBlurBackground(widget
                                          .currentList[
                                              playerProvider.currentMusicIndex]
                                          .imgPath ==
                                      null
                                  ? widget
                                      .currentList[
                                          playerProvider.currentMusicIndex]
                                      .cover_photo_url!
                                  : widget
                                      .currentList[
                                          playerProvider.currentMusicIndex]
                                      .imgPath!),
                              Column(
                                verticalDirection: VerticalDirection.up,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: screenHeight * 0.63,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            MyTheme.data.primaryColor,
                                            MyTheme.data.primaryColor
                                                .withOpacity(0.6),
                                            MyTheme.data.primaryColor
                                                .withOpacity(0.3),
                                            MyTheme.data.primaryColor
                                                .withOpacity(0.0)
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.1,
                                      ),
                                      Container(
                                        height: screenHeight * 0.4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [mainImg(playerProvider)],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget
                                                .currentList[playerProvider
                                                    .currentMusicIndex]
                                                .title_en!,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Visibility(
                                            visible: widget
                                                        .currentList[playerProvider
                                                            .currentMusicIndex]
                                                        .master_quality_url !=
                                                    null &&
                                                widget
                                                    .currentList[playerProvider
                                                        .currentMusicIndex]
                                                    .master_quality_url!
                                                    .isNotEmpty,
                                            child: Image.asset(
                                              'assets/icons/master_star.png',
                                              width: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.015,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget
                                                .currentList[playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .singers
                                                .first
                                                .name_en
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Visibility(
                                            visible: (widget
                                                .currentList[playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .singers
                                                .first
                                                .is_verified),
                                            child: SizedBox(
                                                width: 10,
                                                height: 10,
                                                child: OfficialTick()),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 36),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (playerProvider
                                                      .currentList[playerProvider
                                                          .currentMusicIndex]
                                                      .isPodcast) {
                                                    if (playerProvider
                                                            .currentList[
                                                                playerProvider
                                                                    .currentMusicIndex]
                                                            .others !=
                                                        null) {
                                                      showPodcastsMusics(
                                                          context);
                                                    }
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        SwipeablePageRoute(
                                                            builder: (context) =>
                                                                WithoutTabSongListScreen(
                                                                    'Related Tracks',
                                                                    [])));
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.format_list_bulleted,
                                                    color: Colors.white)),
                                            IconButton(
                                                onPressed: () {
                                                  showOptionMenu(context);
                                                },
                                                icon: Image.asset(
                                                  'assets/icons/menu.png',
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.06,
                                      ),
                                      /*top actions*/ topActions(
                                          playerProvider),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.currentList[playerProvider.currentMusicIndex].visitors} Plays',
                                style: TextStyle(
                                    color:
                                        MyTheme.instance.colors.colorSecondary,
                                    fontSize: 12),
                              )
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                playerProvider.currentDurationStr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                width: screenWidth * 0.6,
                                child: ProgressBar(
                                  progress: playerProvider.currentDuration,
                                  buffered: playerProvider.totalDuration,
                                  total: playerProvider.totalDuration,
                                  progressBarColor:
                                      MyTheme.instance.colors.colorSecondary,
                                  baseBarColor: Colors.white.withOpacity(0.24),
                                  bufferedBarColor:
                                      MyTheme.instance.colors.colorSecondary2,
                                  timeLabelLocation: TimeLabelLocation.none,
                                  thumbColor:
                                      MyTheme.instance.colors.colorSecondary,
                                  barHeight: 3.0,
                                  thumbRadius: 7.0,
                                  onSeek: (duration) {
                                    playerProvider.seekAudio(duration);
                                  },
                                ),
                              ),
                              Text(
                                playerProvider.totalDurationStr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: SizedBox(
                              height: screenHeight * 0.09,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            playerProvider.setShuffleModel();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: MyTheme.instance.colors
                                                    .colorSecondary2
                                                    .withOpacity(playerProvider
                                                            .audioPlayer
                                                            .shuffleModeEnabled
                                                        ? 1
                                                        : 0.5)),
                                            width: 28,
                                            height: 28,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/icons/shuffle.png',
                                                width: 16,
                                                color: playerProvider
                                                        .audioPlayer
                                                        .shuffleModeEnabled
                                                    ? MyTheme.instance.colors
                                                        .colorSecondary
                                                    : MyTheme.instance.colors
                                                        .colorSecondary2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                            onTap: () {
                                              playerProvider
                                                  .previousAudio(context);
                                            },
                                            child: Image.asset(
                                                'assets/icons/play_prvious.png')),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                            highlightColor: Colors.transparent
                                                .withOpacity(0),
                                            splashColor: Colors.transparent
                                                .withOpacity(0),
                                            onTap: () {
                                              changePlayerState(playerProvider);
                                            },
                                            child: Image.asset(
                                              playerProvider.playerState.playing
                                                  ? 'assets/icons/pause.png'
                                                  : 'assets/icons/play.png',
                                              height: screenHeight *
                                                  (playerProvider
                                                          .playerState.playing
                                                      ? 0.085
                                                      : 0.06),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                            onTap: () {
                                              playerProvider.nexAudio(context);
                                            },
                                            child: Image.asset(
                                                'assets/icons/play_next.png')),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            playerProvider.setRepeatModel();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: MyTheme.instance.colors
                                                    .colorSecondary2
                                                    .withOpacity(playerProvider
                                                                .audioPlayer
                                                                .loopMode !=
                                                            LoopMode.off
                                                        ? 1
                                                        : 0.5)),
                                            width: 28,
                                            height: 28,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/icons/repeat.png',
                                                width: 20,
                                                color: playerProvider
                                                            .audioPlayer
                                                            .loopMode !=
                                                        LoopMode.off
                                                    ? MyTheme.instance.colors
                                                        .colorSecondary
                                                    : MyTheme.instance.colors
                                                        .colorSecondary2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Container(
                            width: double.infinity,
                            height: screenHeight * 0.108,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    MyTheme.instance.colors.colorSecondary2
                                        .withOpacity(0.6),
                                    MyTheme.instance.colors.colorSecondary2
                                        .withOpacity(0.4),
                                    MyTheme.instance.colors.colorSecondary2
                                        .withOpacity(0.2),
                                    MyTheme.instance.colors.colorSecondary2
                                        .withOpacity(0.0)
                                  ]),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.7,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color:
                                              MyTheme.instance.colors.myBalck2,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                      highlightColor: Colors
                                                          .transparent
                                                          .withOpacity(0),
                                                      splashColor: Colors
                                                          .transparent
                                                          .withOpacity(0),
                                                      onTap: () {
                                                        if (!_mainProvider
                                                            .downloadedList
                                                            .any((element) =>
                                                                element.id ==
                                                                playerProvider
                                                                    .currentList[
                                                                        playerProvider
                                                                            .currentMusicIndex]
                                                                    .id)) {
                                                          playerProvider.download(
                                                              context,
                                                              playerProvider
                                                                      .currentList[
                                                                  playerProvider
                                                                      .currentMusicIndex]);
                                                          _mainProvider.insertIntoDownloadsList(
                                                              playerProvider
                                                                      .currentList[
                                                                  playerProvider
                                                                      .currentMusicIndex]);
                                                        }
                                                      },
                                                      child: playerProvider
                                                              .currentList[
                                                                  playerProvider
                                                                      .currentMusicIndex]
                                                              .downloading
                                                          ? SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  SleekCircularSlider(
                                                                appearance: CircularSliderAppearance(
                                                                    infoProperties: InfoProperties(
                                                                        mainLabelStyle: TextStyle(
                                                                            color: MyTheme.instance.colors.colorSecondary.withOpacity(
                                                                                0),
                                                                            fontSize:
                                                                                8)),
                                                                    size: 20,
                                                                    customColors: CustomSliderColors(
                                                                        dotColor:
                                                                            Colors
                                                                                .white,
                                                                        trackColor:
                                                                            Colors
                                                                                .white,
                                                                        progressBarColor: MyTheme
                                                                            .instance
                                                                            .colors
                                                                            .colorSecondary)),
                                                                min: 0,
                                                                max: playerProvider
                                                                    .currentList[
                                                                        playerProvider
                                                                            .currentMusicIndex]
                                                                    .maxSize
                                                                    .toDouble(),
                                                                initialValue: playerProvider
                                                                    .currentList[
                                                                        playerProvider
                                                                            .currentMusicIndex]
                                                                    .downloadedProgress
                                                                    .toDouble(),
                                                              ),
                                                            )
                                                          : Image.asset(
                                                              'assets/icons/download.png',
                                                              color: _mainProvider
                                                                      .downloadedList
                                                                      .any((element) =>
                                                                          element
                                                                              .id ==
                                                                          playerProvider
                                                                              .currentList[playerProvider
                                                                                  .currentMusicIndex]
                                                                              .id)
                                                                  ? MyTheme
                                                                      .instance
                                                                      .colors
                                                                      .colorSecondary
                                                                  : Colors
                                                                      .white,
                                                              width: 18,
                                                            )),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                      highlightColor: Colors
                                                          .transparent
                                                          .withOpacity(0),
                                                      splashColor: Colors
                                                          .transparent
                                                          .withOpacity(0),
                                                      onTap: () {
                                                        ShareMusicPicker(
                                                            context,
                                                            _playerProvider
                                                                    .currentList[
                                                                _playerProvider
                                                                    .currentMusicIndex]);
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/share.png',
                                                        width: 18,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    highlightColor: Colors
                                                        .transparent
                                                        .withOpacity(0),
                                                    splashColor: Colors
                                                        .transparent
                                                        .withOpacity(0),
                                                    onTap: () {
                                                      if (playerProvider
                                                          .currentList[
                                                              playerProvider
                                                                  .currentMusicIndex]
                                                          .isPodcast)
                                                        _mainProvider.changePodcastFavoriteState(
                                                            context,
                                                            playerProvider
                                                                .currentList[
                                                                    playerProvider
                                                                        .currentMusicIndex]
                                                                .id!);
                                                      else
                                                        _mainProvider.changeFavoriteState(
                                                            context,
                                                            playerProvider
                                                                .currentList[
                                                                    playerProvider
                                                                        .currentMusicIndex]
                                                                .id!);
                                                      setState(() {
                                                        playerProvider
                                                            .currentList[
                                                                playerProvider
                                                                    .currentMusicIndex]
                                                            .is_favorited = !(playerProvider
                                                                .currentList[
                                                                    playerProvider
                                                                        .currentMusicIndex]
                                                                .is_favorited ??
                                                            false);
                                                        ShowMessage(
                                                            (playerProvider
                                                                        .currentList[
                                                                            playerProvider.currentMusicIndex]
                                                                        .is_favorited ??
                                                                    false)
                                                                ? 'Saved'
                                                                : 'Remove from Saved',
                                                            context);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      child: Image.asset(
                                                        'assets/icons/bookmark2.png',
                                                        color: (playerProvider
                                                                    .currentList[
                                                                        playerProvider
                                                                            .currentMusicIndex]
                                                                    .is_favorited ??
                                                                false)
                                                            ? MyTheme
                                                                .instance
                                                                .colors
                                                                .colorSecondary
                                                            : Colors.white,
                                                        height: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    highlightColor: Colors
                                                        .transparent
                                                        .withOpacity(0),
                                                    splashColor: Colors
                                                        .transparent
                                                        .withOpacity(0),
                                                    onTap: () {
                                                      if (playerProvider
                                                              .totalDuration >
                                                          Duration(seconds: 0))
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                settings: RouteSettings(
                                                                    name:
                                                                        'main'),
                                                                builder: (context) =>
                                                                    CreateClipScreen(widget
                                                                            .currentList[
                                                                        playerProvider
                                                                            .currentMusicIndex])));
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .slow_motion_video_rounded,
                                                      color: Colors.white,
                                                      size: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: Platform.isIOS ? 1 : 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Visibility(
                                                    visible: Platform.isIOS &&
                                                        !isBottomSheetLoaded,
                                                    child:
                                                        AirPlayRoutePickerView(
                                                      tintColor: Colors.white,
                                                      activeTintColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (!isAdLoaded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            playerProvider
                                                .previousAudio(context);
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/play_prvious.png',
                                                color: Colors.grey,
                                                width: 16,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                (playerProvider.currentList[playerProvider.audioPlayer.previousIndex ?? playerProvider.currentList.indexOf(playerProvider.currentList.first)].title_en!).length > 16
                                                    ? (playerProvider
                                                                .currentList[playerProvider
                                                                        .audioPlayer
                                                                        .previousIndex ??
                                                                    playerProvider.currentList.indexOf(playerProvider
                                                                        .currentList
                                                                        .first)]
                                                                .title_en!)
                                                            .substring(0, 16) +
                                                        '...'
                                                    : playerProvider
                                                        .currentList[playerProvider
                                                                .audioPlayer
                                                                .previousIndex ??
                                                            playerProvider.currentList
                                                                .indexOf(playerProvider
                                                                    .currentList
                                                                    .first)]
                                                        .title_en!,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            playerProvider.nexAudio(context);
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                (playerProvider.currentList[playerProvider.audioPlayer.nextIndex ?? playerProvider.currentList.indexOf(playerProvider.currentList.last)].title_en!)
                                                            .length >
                                                        16
                                                    ? (playerProvider
                                                                .currentList[playerProvider
                                                                        .audioPlayer
                                                                        .nextIndex ??
                                                                    playerProvider
                                                                        .currentList
                                                                        .indexOf(playerProvider
                                                                            .currentList
                                                                            .last)]
                                                                .title_en!)
                                                            .substring(0, 16) +
                                                        '...'
                                                    : playerProvider
                                                        .currentList[playerProvider
                                                                .audioPlayer
                                                                .nextIndex ??
                                                            playerProvider.currentList
                                                                .indexOf(playerProvider.currentList.last)]
                                                        .title_en!,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Image.asset(
                                                'assets/icons/play_next.png',
                                                color: Colors.grey,
                                                width: 16,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    verticalDirection: VerticalDirection.up,
                    children: [
                      if (isAdLoaded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: _ad!.size.width.toDouble(),
                              height: _ad!.size.height.toDouble(),
                              alignment: Alignment.center,
                              child: AdWidget(
                                ad: _ad!,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            BottomBar()
          ],
        ));
      }),
    );
  }

  void changePlayerState(PlayerProvider playerProvider) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller..forward();
    if (playerProvider.playerState.playing) {
      playerProvider.pauseAudio();
    } else {
      playerProvider.playAudio();
    }
  }

  Widget mainImg(PlayerProvider playerProvider) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      width: screenHeight * (playerProvider.playerState.playing ? 0.35 : 0.2),
      height: screenHeight * (playerProvider.playerState.playing ? 0.35 : 0.2),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: widget.currentList[playerProvider.currentMusicIndex].imgPath ==
                null
            ? CachedNetworkImage(
                imageUrl: widget.currentList[playerProvider.currentMusicIndex]
                    .cover_photo_url!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                      width: 60,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballBeat,
                        colors: [MyTheme.instance.colors.colorSecondary],
                      ),
                    ),
                  ],
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Image.file(
                new File(widget
                    .currentList[playerProvider.currentMusicIndex].imgPath!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget topActions(PlayerProvider playerProvider) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.15,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: screenWidth * 0.3,
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
          Column(
            children: [
              Container(
                width: screenWidth * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent.withOpacity(0),
                      splashColor: Colors.transparent.withOpacity(0),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.3)),
                        child: Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: screenWidth * 0.06),
                width: screenWidth * 0.24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: playerProvider
                              .currentList[playerProvider.currentMusicIndex]
                              .filePath ==
                          null,
                      child: Stack(
                        children: [
                          isQualityDropDownOpen
                              ? Container(
                                  height: screenWidth *
                                      ((playerProvider
                                                      .currentList[playerProvider
                                                          .currentMusicIndex]
                                                      .master_quality_url !=
                                                  null &&
                                              playerProvider
                                                  .currentList[playerProvider
                                                      .currentMusicIndex]
                                                  .master_quality_url!
                                                  .isNotEmpty)
                                          ? 0.24
                                          : 0.18),
                                  width: screenWidth * 0.18,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: Colors.white.withOpacity(0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: screenWidth * 0.06,
                                          width: screenWidth * 0.18,
                                        ),
                                        InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            setState(() {
                                              playerProvider.changeQuality(
                                                  MusicQualityEnum.low);
                                              isQualityDropDownOpen = false;
                                            });
                                          },
                                          child: Container(
                                            height: screenWidth *
                                                (playerProvider
                                                            .musicQualityEnum ==
                                                        MusicQualityEnum.low
                                                    ? 0.05
                                                    : 0.06),
                                            width: screenWidth * 0.16,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                                color: Colors.white.withOpacity(
                                                    playerProvider
                                                                .musicQualityEnum ==
                                                            MusicQualityEnum.low
                                                        ? 0.3
                                                        : 0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'LQ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            setState(() {
                                              playerProvider.changeQuality(
                                                  MusicQualityEnum.high);
                                              isQualityDropDownOpen = false;
                                            });
                                          },
                                          child: Container(
                                            height: screenWidth *
                                                (playerProvider
                                                            .musicQualityEnum ==
                                                        MusicQualityEnum.high
                                                    ? 0.05
                                                    : 0.06),
                                            width: screenWidth * 0.16,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                                color: Colors.white.withOpacity(
                                                    playerProvider
                                                                .musicQualityEnum ==
                                                            MusicQualityEnum
                                                                .high
                                                        ? 0.3
                                                        : 0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'HQ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        (playerProvider
                                                        .currentList[playerProvider
                                                            .currentMusicIndex]
                                                        .master_quality_url !=
                                                    null &&
                                                playerProvider
                                                    .currentList[playerProvider
                                                        .currentMusicIndex]
                                                    .master_quality_url!
                                                    .isNotEmpty)
                                            ? InkWell(
                                                highlightColor: Colors
                                                    .transparent
                                                    .withOpacity(0),
                                                splashColor: Colors.transparent
                                                    .withOpacity(0),
                                                onTap: () {
                                                  setState(() {
                                                    playerProvider
                                                        .changeQuality(
                                                            MusicQualityEnum
                                                                .master);
                                                    isQualityDropDownOpen =
                                                        false;
                                                  });
                                                },
                                                child: Container(
                                                  height: screenWidth *
                                                      (playerProvider
                                                                  .musicQualityEnum ==
                                                              MusicQualityEnum
                                                                  .master
                                                          ? 0.05
                                                          : 0.06),
                                                  width: screenWidth * 0.16,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16)),
                                                      color: Colors.white
                                                          .withOpacity(playerProvider
                                                                      .musicQualityEnum ==
                                                                  MusicQualityEnum
                                                                      .master
                                                              ? 0.3
                                                              : 0)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Master',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              setState(() {
                                isQualityDropDownOpen = !isQualityDropDownOpen;
                              });
                            },
                            child: Container(
                              height: screenWidth * 0.06,
                              width: screenWidth * 0.18,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white.withOpacity(0.3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                      'assets/icons/arrow_bottom_drop_down.png'),
                                  Text(
                                    musicQualityEnumToString(
                                        playerProvider.musicQualityEnum),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showOptionMenu(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      isBottomSheetLoaded = true;
    });
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
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  if (_authProvider.isLogin) {
                    _mainProvider.changeArtistFavoriteState(
                        context,
                        playerProvider
                            .currentList[playerProvider.currentMusicIndex]
                            .artists
                            .singers
                            .first
                            .id);
                    playerProvider.currentList[playerProvider.currentMusicIndex]
                            .artists.singers.first.is_followed =
                        !(playerProvider
                            .currentList[playerProvider.currentMusicIndex]
                            .artists
                            .singers
                            .first
                            .is_followed);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    showGoToLoginDialog(context, _mainProvider);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      _playerProvider
                              .currentList[_playerProvider.currentMusicIndex]
                              .artists
                              .singers
                              .first
                              .is_followed
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: (playerProvider
                              .currentList[playerProvider.currentMusicIndex]
                              .artists
                              .singers
                              .first
                              .is_followed)
                          ? MyTheme.instance.colors.colorSecondary
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      (_playerProvider
                                  .currentList[
                                      _playerProvider.currentMusicIndex]
                                  .artists
                                  .singers
                                  .first
                                  .is_followed
                              ? 'Unfollow '
                              : 'Follow ') +
                          (_playerProvider
                              .currentList[_playerProvider.currentMusicIndex]
                              .artists
                              .singers
                              .first
                              .display_name),
                      style: TextStyle(
                          color: (playerProvider
                                  .currentList[playerProvider.currentMusicIndex]
                                  .artists
                                  .singers
                                  .first
                                  .is_followed)
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _playerProvider
                          .currentList[_playerProvider.currentMusicIndex]
                          .artists
                          .arrangers
                          .length >
                      0 ||
                  _playerProvider.currentList[_playerProvider.currentMusicIndex]
                          .artists.composers.length >
                      0 ||
                  _playerProvider.currentList[_playerProvider.currentMusicIndex]
                          .artists.lyricists.length >
                      0 ||
                  _playerProvider.currentList[_playerProvider.currentMusicIndex]
                          .artists.mixers.length >
                      0 ||
                  _playerProvider.currentList[_playerProvider.currentMusicIndex]
                          .artists.singers.length >
                      0,
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  showInfo();
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Text(
                        'View Info',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  Navigator.push(
                      context,
                      SwipeablePageRoute(
                          builder: (context) => ArtistDetailScreen(
                              playerProvider
                                  .currentList[playerProvider.currentMusicIndex]
                                  .artists
                                  .singers
                                  .first
                                  .id)));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.mic_none_sharp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Go To Artist',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                onTap: () async {
                  if (_authProvider.isLogin) {
                    if (!_mainProvider.downloadedList.any((element) =>
                        element.id ==
                        playerProvider
                            .currentList[playerProvider.currentMusicIndex]
                            .id)) {
                      playerProvider.download(
                          context,
                          playerProvider
                              .currentList[playerProvider.currentMusicIndex]);
                      _mainProvider.insertIntoDownloadsList(playerProvider
                          .currentList[playerProvider.currentMusicIndex]);
                    }
                  } else {
                    Navigator.pop(context);
                    showGoToLoginDialog(context, _mainProvider);
                  }
                },
                child: Row(
                  children: [
                    Row(
                      children: [
                        playerProvider
                                .currentList[playerProvider.currentMusicIndex]
                                .downloading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                      infoProperties: InfoProperties(
                                          mainLabelStyle: TextStyle(
                                              color: MyTheme.instance.colors
                                                  .colorSecondary
                                                  .withOpacity(0),
                                              fontSize: 8)),
                                      size: 24,
                                      customColors: CustomSliderColors(
                                          dotColor: Colors.white,
                                          trackColor: Colors.white,
                                          progressBarColor: MyTheme
                                              .instance.colors.colorSecondary)),
                                  min: 0,
                                  max: playerProvider
                                      .currentList[
                                          playerProvider.currentMusicIndex]
                                      .maxSize
                                      .toDouble(),
                                  initialValue: playerProvider
                                      .currentList[
                                          playerProvider.currentMusicIndex]
                                      .downloadedProgress
                                      .toDouble(),
                                ),
                              )
                            : Icon(
                                Icons.downloading_rounded,
                                color: _mainProvider.downloadedList.any(
                                        (element) =>
                                            element.id ==
                                            playerProvider
                                                .currentList[playerProvider
                                                    .currentMusicIndex]
                                                .id)
                                    ? MyTheme.instance.colors.colorSecondary
                                    : Colors.white,
                              ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'Download',
                          style: TextStyle(
                              color: _mainProvider.downloadedList.any(
                                      (element) =>
                                          element.id ==
                                          playerProvider
                                              .currentList[playerProvider
                                                  .currentMusicIndex]
                                              .id)
                                  ? MyTheme.instance.colors.colorSecondary
                                  : Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
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
                  if (_authProvider.isLogin) {
                    _mainProvider.changeFavoriteState(
                        context,
                        playerProvider
                            .currentList[playerProvider.currentMusicIndex].id!);
                    playerProvider.currentList[playerProvider.currentMusicIndex]
                        .is_favorited = !(playerProvider
                            .currentList[playerProvider.currentMusicIndex]
                            .is_favorited ??
                        false);
                    Navigator.pop(context);
                    ShowMessage(
                        (playerProvider
                                    .currentList[
                                        playerProvider.currentMusicIndex]
                                    .is_favorited ??
                                false)
                            ? 'Saved'
                            : 'Remove from Saved',
                        context);
                  } else {
                    Navigator.pop(context);
                    showGoToLoginDialog(context, _mainProvider);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: (playerProvider
                                  .currentList[playerProvider.currentMusicIndex]
                                  .is_favorited ??
                              false)
                          ? MyTheme.instance.colors.colorSecondary
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Save To Music',
                      style: TextStyle(
                          color: (playerProvider
                                      .currentList[
                                          playerProvider.currentMusicIndex]
                                      .is_favorited ??
                                  false)
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
                  if (_authProvider.isLogin) {
                    _mainProvider.getUserPlayList(context);
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            settings: RouteSettings(name: 'main'),
                            builder: (context) => AddToPlayListScreen(
                                playerProvider
                                    .currentList[
                                        playerProvider.currentMusicIndex]
                                    .id!)));
                  } else {
                    Navigator.pop(context);
                    showGoToLoginDialog(context, _mainProvider);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.playlist_add_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Add To Playlist',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: playerProvider
                      .currentList[playerProvider.currentMusicIndex].lyrics !=
                  null,
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  showBlurBottomSheet(
                      context,
                      Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.9,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.close,
                                              color: Colors.white)),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              playerProvider
                                                  .currentList[playerProvider
                                                      .currentMusicIndex]
                                                  .lyrics!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 2,
                                                  fontFamily: 'iranYekan'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), () {
                    setState(() {
                      isBottomSheetLoaded = false;
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Text(
                        'Lyrics',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                showTimerList();
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      color: playerProvider.timerEnum == TimerEnum.None
                          ? Colors.white
                          : MyTheme.instance.colors.colorSecondary,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Timer',
                      style: TextStyle(
                          color: playerProvider.timerEnum == TimerEnum.None
                              ? Colors.white
                              : MyTheme.instance.colors.colorSecondary,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                if (playerProvider
                    .currentList[playerProvider.currentMusicIndex].isPodcast)
                  SharePodcastPicker(
                      context,
                      playerProvider
                          .currentList[playerProvider.currentMusicIndex]);
                else
                  ShareMusicPicker(
                      context,
                      _playerProvider
                          .currentList[_playerProvider.currentMusicIndex]);
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    SwipeablePageRoute(
                        settings: RouteSettings(name: 'main'),
                        builder: (context) => CheromecastScreen(playerProvider
                            .currentList[playerProvider.currentMusicIndex])));
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.cast,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Cheromecast',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      });
    }), () {
      setState(() {
        isBottomSheetLoaded = false;
      });
    });
  }

  void showInfo() {
    setState(() {
      isBottomSheetLoaded = true;
    });
    showBlurBottomSheet(
        context,
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Visibility(
                              visible: _playerProvider
                                      .currentList[
                                          _playerProvider.currentMusicIndex]
                                      .artists
                                      .singers
                                      .length >
                                  0,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Singers',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Column(
                                            children: _playerProvider
                                                .currentList[_playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .singers
                                                .map((e) => Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                      child: Text(
                                                          e.display_name,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ))
                                                .toList()),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: _playerProvider
                                      .currentList[
                                          _playerProvider.currentMusicIndex]
                                      .artists
                                      .lyricists
                                      .length >
                                  0,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Lyricists',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Column(
                                            children: _playerProvider
                                                .currentList[_playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .lyricists
                                                .map((e) => Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                      child: Text(
                                                          e.display_name,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ))
                                                .toList()),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: _playerProvider
                                      .currentList[
                                          _playerProvider.currentMusicIndex]
                                      .artists
                                      .composers
                                      .length >
                                  0,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Composers',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Column(
                                            children: _playerProvider
                                                .currentList[_playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .composers
                                                .map((e) => Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                      child: Text(
                                                          e.display_name,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ))
                                                .toList()),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: _playerProvider
                                      .currentList[
                                          _playerProvider.currentMusicIndex]
                                      .artists
                                      .arrangers
                                      .length >
                                  0,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Arrangers',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Column(
                                            children: _playerProvider
                                                .currentList[_playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .arrangers
                                                .map((e) => Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                      child: Text(
                                                          e.display_name,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ))
                                                .toList()),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: _playerProvider
                                      .currentList[
                                          _playerProvider.currentMusicIndex]
                                      .artists
                                      .mixers
                                      .length >
                                  0,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Mixers',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 24),
                                        child: Column(
                                            children: _playerProvider
                                                .currentList[_playerProvider
                                                    .currentMusicIndex]
                                                .artists
                                                .mixers
                                                .map((e) => Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4),
                                                      child: Text(
                                                          e.display_name,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ))
                                                .toList()),
                                      )
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), () {
      setState(() {
        isBottomSheetLoaded = false;
      });
    });
  }

  void showPodcastsMusics(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      isBottomSheetLoaded = true;
    });
    showBlurBottomSheet(
        context,
        Column(
          verticalDirection: VerticalDirection.up,
          children: [
            SizedBox(
              height: screenHeight * 0.9,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, color: Colors.white)),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _playerProvider
                              .currentList[_playerProvider.currentMusicIndex]
                              .others!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ), () {
      setState(() {
        isBottomSheetLoaded = false;
      });
    });
  }

  void showTimerList() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      isBottomSheetLoaded = true;
    });
    showBlurBottomSheet(
        context,
        Column(
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
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.None);
                _playerProvider.cancelStopPlayerTimer();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 24),
                    child: Text(
                      'Stop timer',
                      style: TextStyle(
                          color: _playerProvider.timerEnum == TimerEnum.None
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.TwoHours);
                _playerProvider.stopPlayerIn(7200);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '2 hours',
                      style: TextStyle(
                          color: _playerProvider.timerEnum == TimerEnum.TwoHours
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible: _playerProvider.timerEnum == TimerEnum.TwoHours,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.OneHour);
                _playerProvider.stopPlayerIn(3600);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '1 hour',
                      style: TextStyle(
                          color: _playerProvider.timerEnum == TimerEnum.OneHour
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible: _playerProvider.timerEnum == TimerEnum.OneHour,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.FortyFiveMinutes);
                _playerProvider.stopPlayerIn(2700);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '45 minutes',
                      style: TextStyle(
                          color: _playerProvider.timerEnum ==
                                  TimerEnum.FortyFiveMinutes
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible:
                        _playerProvider.timerEnum == TimerEnum.FortyFiveMinutes,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.ThirtyMinutes);
                _playerProvider.stopPlayerIn(1800);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '30 minutes',
                      style: TextStyle(
                          color: _playerProvider.timerEnum ==
                                  TimerEnum.ThirtyMinutes
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible:
                        _playerProvider.timerEnum == TimerEnum.ThirtyMinutes,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.FifteenMinutes);
                _playerProvider.stopPlayerIn(900);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '15 minutes',
                      style: TextStyle(
                          color: _playerProvider.timerEnum ==
                                  TimerEnum.FifteenMinutes
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible:
                        _playerProvider.timerEnum == TimerEnum.FifteenMinutes,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.TenMinutes);
                _playerProvider.stopPlayerIn(600);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '10 minutes',
                      style: TextStyle(
                          color:
                              _playerProvider.timerEnum == TimerEnum.TenMinutes
                                  ? MyTheme.instance.colors.colorSecondary
                                  : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible: _playerProvider.timerEnum == TimerEnum.TenMinutes,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                Navigator.pop(context);
                _playerProvider.changeTimerEnum(TimerEnum.FiveMinutes);
                _playerProvider.stopPlayerIn(300);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                    child: Text(
                      '5 minutes',
                      style: TextStyle(
                          color:
                              _playerProvider.timerEnum == TimerEnum.FiveMinutes
                                  ? MyTheme.instance.colors.colorSecondary
                                  : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Visibility(
                    visible: _playerProvider.timerEnum == TimerEnum.FiveMinutes,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: DateTime.now().add(
                        Duration(
                          seconds: _playerProvider.stopPlayerStart,
                        ),
                      ),
                      enableDescriptions: false,
                      colonsTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      timeTextStyle: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                      spacerWidth: 4,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 0, 24),
                  child: Text(
                    'Turn off music in',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ), () {
      setState(() {
        isBottomSheetLoaded = false;
      });
    });
  }
}
