import 'dart:io';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/my_widgets/vertical_video_item.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class MiniScreenVideoPlayer extends StatefulWidget {
  List<VideoModel> videoList = [];
  int index = 0;
  String title = '';
  String iconUrl = '';

  MiniScreenVideoPlayer(this.videoList, this.index, this.title, this.iconUrl);

  @override
  _MiniScreenVideoPlayerState createState() => _MiniScreenVideoPlayerState();
}

class _MiniScreenVideoPlayerState extends State<MiniScreenVideoPlayer>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  late AnimationController _animateController;
  bool isLoading = false;
  MainProvider _mainProvider = MainProvider();
  AuthProvider _authProvider = new AuthProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  int rotate = 0;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    MainProvider mainProvider = context.read<MainProvider>();
    if (widget.videoList[widget.index].admob_id != null ||
        (mainProvider.adsModel.admob_android_id.isNotEmpty &&
            mainProvider.adsModel.admob_ios_id.isNotEmpty)) {
      _ad = BannerAd(
          size: AdSize.banner,
          adUnitId: widget.videoList[widget.index].admob_id ??
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
    _playerProvider.pauseAudio();
    playVideo();
    super.initState();
  }

  @override
  void dispose() {
    if (_ad != null) {
      _ad!.dispose();
      isAdLoaded = false;
    }
    _controller!.pause();
    _controller!.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (widget.videoList[widget.index].currentDuration > Duration(seconds: 0) &&
        _controller != null) {
      _controller!.seekTo(widget.videoList[widget.index].currentDuration);
      widget.videoList[widget.index].currentDuration = Duration(seconds: 0);
    }
    return Consumer3<MainProvider, AuthProvider, PlayerProvider>(
        builder: (context, mainProvider, authProvider, playerProvider, _) {
      playerProvider.pauseAudio();
      _mainProvider = mainProvider;
      _authProvider = authProvider;
      return Scaffold(
        backgroundColor: MyTheme.instance.colors.secondColorPrimary,
        body: Column(
          children: [
            Visibility(
              visible: rotate == 0,
              child: Column(
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Image.asset(
                              widget.iconUrl,
                              width: 22,
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
                ],
              ),
            ),
            showPlayer(),
            if (isAdLoaded)
              Visibility(
                visible: rotate == 0,
                child: Container(
                  width: _ad!.size.width.toDouble(),
                  height: _ad!.size.height.toDouble(),
                  alignment: Alignment.center,
                  child: AdWidget(
                    ad: _ad!,
                  ),
                ),
              ),
            Visibility(
              visible: rotate == 0,
              child: Expanded(
                child: ListView(
                  children: widget.videoList
                      .map((e) => InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              setState(() {
                                isLoading = true;
                              });
                              widget.index = widget.videoList.indexOf(e);
                              _controller!.dispose();
                              playVideo();
                            },
                            child: VerticalVideoItem(e),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget showPlayer() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
        valueListenable: _controller!,
        builder: (context, VideoPlayerValue value, child) {
          String positionSecond = (value.position.inSeconds % 60 > 9
              ? (value.position.inSeconds % 60).toString()
              : '0' + (value.position.inSeconds % 60).toString());
          String durationSecond = (value.duration.inSeconds % 60 > 9
              ? (value.duration.inSeconds % 60).toString()
              : '0' + (value.duration.inSeconds % 60).toString());
          widget.videoList[widget.index].currentDuration = value.position;
          return Consumer<MainProvider>(builder: (context, mainProvider, _) {
            return Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: rotate == 0 ? screenHeight * 0.3 : screenHeight,
                  child: value.isInitialized && !isLoading
                      ? Stack(
                          children: [
                            InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  mainProvider.showAndHideMenu();
                                },
                                child: RotatedBox(
                                    quarterTurns: rotate,
                                    child: Center(
                                      child: AspectRatio(
                                          aspectRatio:
                                              _controller!.value.aspectRatio,
                                          child: VideoPlayer(_controller!)),
                                    ))),
                            /*in full screen*/ Visibility(
                              visible: mainProvider.showMenu && rotate == 1,
                              child: RotatedBox(
                                quarterTurns: rotate,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: screenWidth * 0.13,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, screenHeight * 0.02, 16, 0),
                                          child: Center(
                                            child: SizedBox(
                                              height: screenHeight * 0.3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                          (widget
                                                                  .videoList[
                                                                      widget
                                                                          .index]
                                                                  .artists
                                                                  .singers
                                                                  .first
                                                                  .name_en) +
                                                              ' - "' +
                                                              (widget
                                                                      .videoList[
                                                                          widget
                                                                              .index]
                                                                      .title_en ??
                                                                  '') +
                                                              '"',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    mainProvider
                                                                            .isQualityOpen
                                                                        ? 0
                                                                        : 16.7),
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              highlightColor: Colors
                                                                  .transparent
                                                                  .withOpacity(
                                                                      0),
                                                              splashColor: Colors
                                                                  .transparent
                                                                  .withOpacity(
                                                                      0),
                                                              onTap: () {
                                                                setState(() {
                                                                  mainProvider
                                                                          .isQualityOpen =
                                                                      !mainProvider
                                                                          .isQualityOpen;
                                                                });
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/setting.png',
                                                                width: 24,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Visibility(
                                                              visible: mainProvider
                                                                  .isQualityOpen,
                                                              child: Container(
                                                                height: screenHeight *
                                                                    (widget.videoList[widget.index]
                                                                            .qualityCount *
                                                                        0.033),
                                                                width:
                                                                    screenHeight *
                                                                        0.07,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            12)),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.2)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          2),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      widget.videoList[widget.index].low_quality_url !=
                                                                              null
                                                                          ? InkWell(
                                                                              highlightColor: Colors.transparent.withOpacity(0),
                                                                              splashColor: Colors.transparent.withOpacity(0),
                                                                              onTap: () {
                                                                                if (widget.videoList[widget.index].quality != 0) {
                                                                                  setState(() {
                                                                                    isLoading = true;
                                                                                    widget.videoList[widget.index].quality = 0;
                                                                                    mainProvider.isQualityOpen = false;
                                                                                    _controller!.dispose();
                                                                                    _controller = VideoPlayerController.network(widget.videoList[widget.index].low_quality_url!)
                                                                                      ..initialize().then((_) {
                                                                                        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                                        setState(() {
                                                                                          _controller!.seekTo(widget.videoList[widget.index].currentDuration);
                                                                                          _controller!.play();
                                                                                          isLoading = false;
                                                                                          _animateController = AnimationController(
                                                                                            duration: const Duration(milliseconds: 500),
                                                                                            vsync: this,
                                                                                          );
                                                                                        });
                                                                                      });
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: screenHeight * (widget.videoList[widget.index].quality == 0 ? 0.025 : 0.03),
                                                                                width: screenHeight * 0.06,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white.withOpacity(widget.videoList[widget.index].quality == 0 ? 0.3 : 0)),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      '480',
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                      widget.videoList[widget.index].normal_quality_url !=
                                                                              null
                                                                          ? InkWell(
                                                                              highlightColor: Colors.transparent.withOpacity(0),
                                                                              splashColor: Colors.transparent.withOpacity(0),
                                                                              onTap: () {
                                                                                if (widget.videoList[widget.index].quality != 1) {
                                                                                  setState(() {
                                                                                    isLoading = true;
                                                                                    widget.videoList[widget.index].quality = 1;
                                                                                    mainProvider.isQualityOpen = false;
                                                                                    _controller!.dispose();
                                                                                    _controller = VideoPlayerController.network(widget.videoList[widget.index].normal_quality_url!)
                                                                                      ..initialize().then((_) {
                                                                                        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                                        setState(() {
                                                                                          _controller!.seekTo(widget.videoList[widget.index].currentDuration);
                                                                                          _controller!.play();
                                                                                          isLoading = false;
                                                                                          _animateController = AnimationController(
                                                                                            duration: const Duration(milliseconds: 500),
                                                                                            vsync: this,
                                                                                          );
                                                                                        });
                                                                                      });
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: screenHeight * (widget.videoList[widget.index].quality == 1 ? 0.025 : 0.03),
                                                                                width: screenHeight * 0.06,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white.withOpacity(widget.videoList[widget.index].quality == 1 ? 0.3 : 0)),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      '720',
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                      widget.videoList[widget.index].high_quality_url !=
                                                                              null
                                                                          ? InkWell(
                                                                              highlightColor: Colors.transparent.withOpacity(0),
                                                                              splashColor: Colors.transparent.withOpacity(0),
                                                                              onTap: () {
                                                                                if (widget.videoList[widget.index].quality != 2) {
                                                                                  setState(() {
                                                                                    isLoading = true;
                                                                                    widget.videoList[widget.index].quality = 2;
                                                                                    mainProvider.isQualityOpen = false;
                                                                                    _controller!.dispose();
                                                                                    _controller = VideoPlayerController.network(widget.videoList[widget.index].high_quality_url!)
                                                                                      ..initialize().then((_) {
                                                                                        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                                        setState(() {
                                                                                          _controller!.seekTo(widget.videoList[widget.index].currentDuration);
                                                                                          _controller!.play();
                                                                                          isLoading = false;
                                                                                          _animateController = AnimationController(
                                                                                            duration: const Duration(milliseconds: 500),
                                                                                            vsync: this,
                                                                                          );
                                                                                        });
                                                                                      });
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                height: screenHeight * (widget.videoList[widget.index].quality == 2 ? 0.025 : 0.03),
                                                                                width: screenHeight * 0.06,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white.withOpacity(widget.videoList[widget.index].quality == 2 ? 0.3 : 0)),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      '1080',
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Image.asset(
                                                              'assets/icons/picture_in_picture.png',
                                                              width: 24,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: InkWell(
                                                              highlightColor: Colors
                                                                  .transparent
                                                                  .withOpacity(
                                                                      0),
                                                              splashColor: Colors
                                                                  .transparent
                                                                  .withOpacity(
                                                                      0),
                                                              onTap: () {
                                                                setState(() {
                                                                  if (rotate ==
                                                                      0) {
                                                                    rotate = 1;
                                                                    SystemChrome.setEnabledSystemUIMode(
                                                                        SystemUiMode
                                                                            .immersiveSticky,
                                                                        overlays: [
                                                                          SystemUiOverlay
                                                                              .top,
                                                                          SystemUiOverlay
                                                                              .bottom,
                                                                        ]);
                                                                  } else {
                                                                    rotate = 0;
                                                                    SystemChrome.setEnabledSystemUIOverlays(
                                                                        SystemUiOverlay
                                                                            .values);
                                                                  }
                                                                });
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/fullscreen.png',
                                                                width: 24,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 12, 20, 0),
                                            child: ValueListenableBuilder(
                                              builder: (context,
                                                  VideoPlayerValue value,
                                                  child) {
                                                widget.videoList[widget.index]
                                                        .currentDuration =
                                                    value.position;
                                                String positionSecond = (value
                                                                .position
                                                                .inSeconds %
                                                            60 >
                                                        9
                                                    ? (value.position
                                                                .inSeconds %
                                                            60)
                                                        .toString()
                                                    : '0' +
                                                        (value.position
                                                                    .inSeconds %
                                                                60)
                                                            .toString());
                                                String durationSecond = (value
                                                                .duration
                                                                .inSeconds %
                                                            60 >
                                                        9
                                                    ? (value.duration
                                                                .inSeconds %
                                                            60)
                                                        .toString()
                                                    : '0' +
                                                        (value.duration
                                                                    .inSeconds %
                                                                60)
                                                            .toString());

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '${value.position.inMinutes}:$positionSecond',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            screenHeight * 0.88,
                                                        child: ProgressBar(
                                                          progress:
                                                              value.position,
                                                          buffered:
                                                              value.duration,
                                                          total: value.duration,
                                                          progressBarColor:
                                                              MyTheme
                                                                  .instance
                                                                  .colors
                                                                  .colorSecondary,
                                                          baseBarColor: Colors
                                                              .white
                                                              .withOpacity(
                                                                  0.24),
                                                          bufferedBarColor: MyTheme
                                                              .instance
                                                              .colors
                                                              .colorSecondary2,
                                                          timeLabelLocation:
                                                              TimeLabelLocation
                                                                  .none,
                                                          thumbColor: MyTheme
                                                              .instance
                                                              .colors
                                                              .colorSecondary
                                                              .withOpacity(0),
                                                          barHeight: 3.0,
                                                          thumbRadius: 5.0,
                                                          onSeek:
                                                              (duration) async {
                                                            _controller!.seekTo(
                                                                duration);
                                                          },
                                                        )),
                                                    Text(
                                                      '${value.duration.inMinutes}:$durationSecond',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                );
                                              },
                                              valueListenable: _controller!,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 0, 20, 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                  'assets/icons/download_video.png',
                                                  width: 24,
                                                  height: 24),
                                              InkWell(
                                                  highlightColor: Colors
                                                      .transparent
                                                      .withOpacity(0),
                                                  splashColor: Colors
                                                      .transparent
                                                      .withOpacity(0),
                                                  onTap: () {
                                                    changePlayerState(
                                                        value.isPlaying);
                                                  },
                                                  child: Image.asset(
                                                    value.isPlaying
                                                        ? 'assets/icons/pause.png'
                                                        : 'assets/icons/play.png',
                                                    height: screenWidth * 0.2,
                                                  )),
                                              Image.asset(
                                                  'assets/icons/menu.png',
                                                  width: 24,
                                                  height: 24)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*in mini screen*/ Visibility(
                              visible: mainProvider.showMenu && rotate == 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: InkWell(
                                            highlightColor: Colors.transparent
                                                .withOpacity(0),
                                            splashColor: Colors.transparent
                                                .withOpacity(0),
                                            onTap: () {
                                              if (widget.index != 0) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                widget.index = widget.index - 1;
                                                _controller!.dispose();
                                                _controller = VideoPlayerController
                                                    .network(widget
                                                            .videoList[
                                                                widget.index]
                                                            .low_quality_url ??
                                                        widget
                                                            .videoList[
                                                                widget.index]
                                                            .normal_quality_url ??
                                                        widget
                                                            .videoList[
                                                                widget.index]
                                                            .high_quality_url!)
                                                  ..initialize().then((_) {
                                                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                    setState(() {
                                                      _controller!.play();
                                                      isLoading = false;
                                                      _animateController =
                                                          AnimationController(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        vsync: this,
                                                      );
                                                    });
                                                    mainProvider
                                                        .showAndHideMenu();
                                                  });
                                              }
                                            },
                                            child: Image.asset(
                                              'assets/icons/video_previous.png',
                                              width: screenWidth * 0.1,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                changePlayerState(
                                                    value.isPlaying);
                                              },
                                              child: Image.asset(
                                                value.isPlaying
                                                    ? 'assets/icons/pause.png'
                                                    : 'assets/icons/play.png',
                                                width: screenWidth * 0.2,
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: InkWell(
                                            highlightColor: Colors.transparent
                                                .withOpacity(0),
                                            splashColor: Colors.transparent
                                                .withOpacity(0),
                                            onTap: () {
                                              if (widget.index !=
                                                  widget.videoList.indexOf(
                                                      widget.videoList.last)) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                widget.index = widget.index + 1;
                                                _controller!.dispose();
                                                _controller = VideoPlayerController
                                                    .network(widget
                                                            .videoList[
                                                                widget.index]
                                                            .low_quality_url ??
                                                        widget
                                                            .videoList[
                                                                widget.index]
                                                            .normal_quality_url ??
                                                        widget
                                                            .videoList[
                                                                widget.index]
                                                            .high_quality_url!)
                                                  ..initialize().then((_) {
                                                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                    setState(() {
                                                      _controller!.play();
                                                      isLoading = false;
                                                      _animateController =
                                                          AnimationController(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        vsync: this,
                                                      );
                                                    });
                                                    mainProvider
                                                        .showAndHideMenu();
                                                  });
                                              }
                                            },
                                            child: Image.asset(
                                                'assets/icons/video_next.png',
                                                width: screenWidth * 0.1),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            /*in mini screen*/ Visibility(
                              visible: mainProvider.showMenu && rotate == 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                verticalDirection: VerticalDirection.up,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.2,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: mainProvider.isQualityOpen
                                                  ? 0
                                                  : 18.8,
                                              bottom: 16),
                                          child: Column(
                                            verticalDirection:
                                                VerticalDirection.up,
                                            children: [
                                              InkWell(
                                                highlightColor: Colors
                                                    .transparent
                                                    .withOpacity(0),
                                                splashColor: Colors.transparent
                                                    .withOpacity(0),
                                                onTap: () {
                                                  setState(() {
                                                    mainProvider.isQualityOpen =
                                                        !mainProvider
                                                            .isQualityOpen;
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/icons/setting.png',
                                                  width: 24,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Visibility(
                                                visible:
                                                    mainProvider.isQualityOpen,
                                                child: Container(
                                                  height: screenWidth *
                                                      (widget
                                                              .videoList[
                                                                  widget.index]
                                                              .qualityCount *
                                                          0.066),
                                                  width: screenWidth * 0.15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12)),
                                                      color: Colors.white
                                                          .withOpacity(0.2)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        widget
                                                                    .videoList[
                                                                        widget
                                                                            .index]
                                                                    .low_quality_url !=
                                                                null
                                                            ? InkWell(
                                                                highlightColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                splashColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                onTap: () {
                                                                  if (widget
                                                                          .videoList[
                                                                              widget.index]
                                                                          .quality !=
                                                                      0) {
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          true;
                                                                      widget
                                                                          .videoList[
                                                                              widget.index]
                                                                          .quality = 0;
                                                                      mainProvider
                                                                              .isQualityOpen =
                                                                          false;
                                                                      _controller!
                                                                          .dispose();
                                                                      _controller = VideoPlayerController.network(widget
                                                                          .videoList[widget
                                                                              .index]
                                                                          .low_quality_url!)
                                                                        ..initialize()
                                                                            .then((_) {
                                                                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                          setState(
                                                                              () {
                                                                            _controller!.seekTo(widget.videoList[widget.index].currentDuration);
                                                                            _controller!.play();
                                                                            isLoading =
                                                                                false;
                                                                            _animateController =
                                                                                AnimationController(
                                                                              duration: const Duration(milliseconds: 500),
                                                                              vsync: this,
                                                                            );
                                                                          });
                                                                        });
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: screenWidth *
                                                                      (widget.videoList[widget.index].quality ==
                                                                              0
                                                                          ? 0.05
                                                                          : 0.055),
                                                                  width:
                                                                      screenWidth *
                                                                          0.135,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              16)),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(widget.videoList[widget.index].quality == 0
                                                                              ? 0.3
                                                                              : 0)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        '480',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        widget
                                                                    .videoList[
                                                                        widget
                                                                            .index]
                                                                    .normal_quality_url !=
                                                                null
                                                            ? InkWell(
                                                                highlightColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                splashColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                onTap: () {
                                                                  if (widget
                                                                          .videoList[
                                                                              widget.index]
                                                                          .quality !=
                                                                      1) {
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          true;
                                                                      widget
                                                                          .videoList[
                                                                              widget.index]
                                                                          .quality = 1;
                                                                      mainProvider
                                                                              .isQualityOpen =
                                                                          false;
                                                                      _controller!
                                                                          .dispose();
                                                                      _controller = VideoPlayerController.network(widget
                                                                          .videoList[widget
                                                                              .index]
                                                                          .normal_quality_url!)
                                                                        ..initialize()
                                                                            .then((_) {
                                                                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                          setState(
                                                                              () {
                                                                            _controller!.seekTo(widget.videoList[widget.index].currentDuration);
                                                                            _controller!.play();
                                                                            isLoading =
                                                                                false;
                                                                            _animateController =
                                                                                AnimationController(
                                                                              duration: const Duration(milliseconds: 500),
                                                                              vsync: this,
                                                                            );
                                                                          });
                                                                        });
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: screenWidth *
                                                                      (widget.videoList[widget.index].quality ==
                                                                              1
                                                                          ? 0.05
                                                                          : 0.055),
                                                                  width:
                                                                      screenWidth *
                                                                          0.135,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              16)),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(widget.videoList[widget.index].quality == 1
                                                                              ? 0.3
                                                                              : 0)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        '720',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        widget
                                                                    .videoList[
                                                                        widget
                                                                            .index]
                                                                    .high_quality_url !=
                                                                null
                                                            ? InkWell(
                                                                highlightColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                splashColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                onTap: () {
                                                                  if (widget
                                                                          .videoList[
                                                                              widget.index]
                                                                          .quality !=
                                                                      2) {
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          true;
                                                                      widget
                                                                          .videoList[
                                                                              widget.index]
                                                                          .quality = 2;
                                                                      mainProvider
                                                                              .isQualityOpen =
                                                                          false;
                                                                      _controller!
                                                                          .dispose();
                                                                      _controller = VideoPlayerController.network(widget
                                                                          .videoList[widget
                                                                              .index]
                                                                          .high_quality_url!)
                                                                        ..initialize()
                                                                            .then((_) {
                                                                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                          setState(
                                                                              () {
                                                                            _controller!.seekTo(widget.videoList[widget.index].currentDuration);
                                                                            _controller!.play();
                                                                            isLoading =
                                                                                false;
                                                                            _animateController =
                                                                                AnimationController(
                                                                              duration: const Duration(milliseconds: 500),
                                                                              vsync: this,
                                                                            );
                                                                          });
                                                                        });
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: screenWidth *
                                                                      (widget.videoList[widget.index].quality ==
                                                                              2
                                                                          ? 0.05
                                                                          : 0.055),
                                                                  width:
                                                                      screenWidth *
                                                                          0.135,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              16)),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(widget.videoList[widget.index].quality == 2
                                                                              ? 0.3
                                                                              : 0)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        '1080',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.2,
                                        child: Column(
                                          verticalDirection:
                                              VerticalDirection.up,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 16),
                                              child: InkWell(
                                                highlightColor: Colors
                                                    .transparent
                                                    .withOpacity(0),
                                                splashColor: Colors.transparent
                                                    .withOpacity(0),
                                                onTap: () {
                                                  setState(() {
                                                    if (rotate == 0) {
                                                      rotate = 1;
                                                      SystemChrome
                                                          .setEnabledSystemUIMode(
                                                              SystemUiMode
                                                                  .immersiveSticky,
                                                              overlays: [
                                                            SystemUiOverlay.top,
                                                            SystemUiOverlay
                                                                .bottom,
                                                          ]);
                                                    } else {
                                                      rotate = 0;
                                                      SystemChrome
                                                          .setEnabledSystemUIOverlays(
                                                              SystemUiOverlay
                                                                  .values);
                                                    }
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/icons/fullscreen.png',
                                                  width: 24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : MyCircleLoading(),
                ),
                Visibility(
                  visible: rotate == 0,
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${value.position.inMinutes}:$positionSecond',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                              width: screenWidth * 0.7,
                              child: ProgressBar(
                                progress: value.position,
                                buffered: value.duration,
                                total: value.duration,
                                progressBarColor:
                                    MyTheme.instance.colors.colorSecondary,
                                baseBarColor: Colors.white.withOpacity(0.24),
                                bufferedBarColor:
                                    MyTheme.instance.colors.colorSecondary2,
                                timeLabelLocation: TimeLabelLocation.none,
                                thumbColor: MyTheme
                                    .instance.colors.colorSecondary
                                    .withOpacity(0),
                                barHeight: 3.0,
                                thumbRadius: 5.0,
                                onSeek: (duration) {
                                  _controller!.seekTo(duration);
                                },
                              )),
                          Text(
                            '${value.duration.inMinutes}:$durationSecond',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      )),
                ),
                Visibility(
                  visible: rotate == 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 12,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalDirection: VerticalDirection.up,
                                  children: [
                                    Text(
                                        (widget.videoList[widget.index]
                                                            .title_en ??
                                                        '')
                                                    .length >
                                                18
                                            ? (widget.videoList[widget.index]
                                                            .title_en ??
                                                        '')
                                                    .substring(0, 18) +
                                                '...'
                                            : widget.videoList[widget.index]
                                                    .title_en ??
                                                '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(
                                        (widget.videoList[widget.index].artists
                                                        .singers.first.name_en)
                                                    .length >
                                                20
                                            ? (widget
                                                        .videoList[widget.index]
                                                        .artists
                                                        .singers
                                                        .first
                                                        .name_en)
                                                    .substring(0, 20) +
                                                '...'
                                            : widget.videoList[widget.index]
                                                .artists.singers.first.name_en,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ))
                                  ])),
                          Expanded(
                              flex: 8,
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
                                        ShareVideoPicker(context,
                                            widget.videoList[widget.index]);
                                      },
                                      child: Image.asset(
                                        'assets/icons/share2.png',
                                        height: 20,
                                        color: Colors.grey,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Visibility(
                                      visible: _authProvider.isLogin,
                                      child: InkWell(
                                        highlightColor:
                                            Colors.transparent.withOpacity(0),
                                        splashColor:
                                            Colors.transparent.withOpacity(0),
                                        onTap: () {
                                          mainProvider.changeVideoFavoriteState(
                                              context,
                                              widget
                                                  .videoList[widget.index].id!);
                                          setState(() {
                                            if (widget.videoList[widget.index]
                                                    .is_favorited ??
                                                false)
                                              mainProvider
                                                  .changeVideoFavoriteList(
                                                      false,
                                                      widget.videoList[
                                                          widget.index]);
                                            else
                                              mainProvider
                                                  .changeVideoFavoriteList(
                                                      true,
                                                      widget.videoList[
                                                          widget.index]);
                                            widget.videoList[widget.index]
                                                .is_favorited = !(widget
                                                    .videoList[widget.index]
                                                    .is_favorited ??
                                                false);
                                          });
                                          ShowMessage(
                                              (widget.videoList[widget.index]
                                                          .is_favorited ??
                                                      false)
                                                  ? 'Saved'
                                                  : 'Remove from Saved',
                                              context);
                                        },
                                        child: Image.asset(
                                          'assets/icons/bookmark.png',
                                          height: 20,
                                          color: (widget.videoList[widget.index]
                                                      .is_favorited ??
                                                  false)
                                              ? MyTheme.instance.colors
                                                  .colorSecondary
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ]))
                        ]),
                  ),
                ),
              ],
            );
          });
        });
  }

  playVideo() {
    String url = '';
    if (widget.videoList[widget.index].quality == 0) {
      if (widget.videoList[widget.index].low_quality_url != null) {
        url = widget.videoList[widget.index].low_quality_url!;
      } else if (widget.videoList[widget.index].normal_quality_url != null) {
        url = widget.videoList[widget.index].normal_quality_url!;
        widget.videoList[widget.index].quality = 1;
      } else {
        url = widget.videoList[widget.index].high_quality_url!;
        widget.videoList[widget.index].quality = 2;
      }
    } else if (widget.videoList[widget.index].quality == 1) {
      if (widget.videoList[widget.index].normal_quality_url != null) {
        url = widget.videoList[widget.index].normal_quality_url!;
      } else if (widget.videoList[widget.index].low_quality_url != null) {
        url = widget.videoList[widget.index].low_quality_url!;
        widget.videoList[widget.index].quality = 0;
      } else {
        url = widget.videoList[widget.index].high_quality_url!;
        widget.videoList[widget.index].quality = 2;
      }
    } else {
      if (widget.videoList[widget.index].high_quality_url != null) {
        url = widget.videoList[widget.index].high_quality_url!;
      } else if (widget.videoList[widget.index].low_quality_url != null) {
        url = widget.videoList[widget.index].low_quality_url!;
        widget.videoList[widget.index].quality = 0;
      } else {
        url = widget.videoList[widget.index].normal_quality_url!;
        widget.videoList[widget.index].quality = 1;
      }
    }
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller!.play();
          isLoading = false;
          _animateController = AnimationController(
            duration: const Duration(milliseconds: 500),
            vsync: this,
          );
        });
        _mainProvider.showAndHideMenu();
      });
  }

  void changePlayerState(bool isPlay) {
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animateController..forward();
    if (isPlay) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }
}
