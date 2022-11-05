import 'dart:async';
import 'dart:math' as math;
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPalyer extends StatefulWidget {
  VideoModel videoModel = new VideoModel();
  Duration currentDuration = Duration();

  FullScreenVideoPalyer(this.videoModel, this.currentDuration);

  @override
  _FullScreenVideoPalyerState createState() => _FullScreenVideoPalyerState();
}

class _FullScreenVideoPalyerState extends State<FullScreenVideoPalyer>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool showMenu = true;
  late Timer _timer;
  int _start = 5;
  bool isPlay = false;
  late AnimationController _animateController;
  bool isQualityOpen = false;
  bool isLoading = false;

  @override
  initState() {

    // AutoOrientation.landscapeLeftMode();
    // AutoOrientation.fullAutoMode();
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    String url = '';
    if (widget.videoModel.quality == 0) {
      if (widget.videoModel.low_quality_url != null) {
        url = widget.videoModel.low_quality_url!;
      } else if (widget.videoModel.normal_quality_url != null) {
        url = widget.videoModel.normal_quality_url!;
        widget.videoModel.quality = 1;
      } else {
        url = widget.videoModel.high_quality_url!;
        widget.videoModel.quality = 2;
      }
    } else if (widget.videoModel.quality == 1) {
      if (widget.videoModel.normal_quality_url != null) {
        url = widget.videoModel.normal_quality_url!;
      } else if (widget.videoModel.low_quality_url != null) {
        url = widget.videoModel.low_quality_url!;
        widget.videoModel.quality = 0;
      } else {
        url = widget.videoModel.high_quality_url!;
        widget.videoModel.quality = 2;
      }
    } else {
      if (widget.videoModel.high_quality_url != null) {
        url = widget.videoModel.high_quality_url!;
      } else if (widget.videoModel.low_quality_url != null) {
        url = widget.videoModel.low_quality_url!;
        widget.videoModel.quality = 0;
      } else {
        url = widget.videoModel.normal_quality_url!;
        widget.videoModel.quality = 1;
      }
    }
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller!
              .play()
              .then((value) => _controller!.seekTo(widget.currentDuration));
          isPlay = true;
          _animateController = AnimationController(
            duration: const Duration(milliseconds: 500),
            vsync: this,
          );
        });
        showAndHideMenu();
      });
    super.initState();
  }

  @override
  dispose() {
    _timer.cancel();
    if (_controller != null) _controller!.dispose();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void showAndHideMenu() {
    setState(() {
      showMenu = true;
      _start = 5;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            showMenu = false;
            isQualityOpen = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: _controller!.value.isInitialized && !isLoading
              ? Stack(
                  children: [
                    InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                        onTap: () {
                          showAndHideMenu();
                        },
                        child: VideoPlayer(_controller!)),
                    Visibility(
                      visible: showMenu,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: screenHeight * 0.13,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    16, screenHeight * 0.04, 8, 0),
                                child: Center(
                                  child: SizedBox(
                                    height: screenHeight * 0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                (widget
                                                        .videoModel
                                                        .artists
                                                        .singers
                                                        .first
                                                        .name_en) +
                                                    ' - "' +
                                                    (widget.videoModel
                                                            .title_en ??
                                                        '') +
                                                    '"',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isQualityOpen ? 0 : 16.7),
                                              child: Column(
                                                children: [
                                                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                                    onTap: () {
                                                      setState(() {
                                                        isQualityOpen =
                                                            !isQualityOpen;
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
                                                    visible: isQualityOpen,
                                                    child: Container(
                                                      height: screenWidth *
                                                          (widget.videoModel
                                                                  .qualityCount *
                                                              0.033),
                                                      width: screenWidth * 0.07,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.2)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 2),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            widget.videoModel
                                                                        .low_quality_url !=
                                                                    null
                                                                ? InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                                                    onTap: () {
                                                                      if (widget
                                                                              .videoModel
                                                                              .quality !=
                                                                          0) {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                          widget
                                                                              .videoModel
                                                                              .quality = 0;
                                                                          isQualityOpen =
                                                                              false;
                                                                          _controller!
                                                                              .dispose();
                                                                          _controller = VideoPlayerController.network(widget
                                                                              .videoModel
                                                                              .low_quality_url!)
                                                                            ..initialize().then((_) {
                                                                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                              setState(() {
                                                                                _controller!.seekTo(widget.videoModel.currentDuration);
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
                                                                    child:
                                                                        Container(
                                                                      height: screenWidth *
                                                                          (widget.videoModel.quality == 0
                                                                              ? 0.025
                                                                              : 0.03),
                                                                      width: screenWidth *
                                                                          0.06,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              16)),
                                                                          color: Colors.white.withOpacity(widget.videoModel.quality == 0
                                                                              ? 0.3
                                                                              : 0)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '480',
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                            widget.videoModel
                                                                        .normal_quality_url !=
                                                                    null
                                                                ? InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                                                    onTap: () {
                                                                      if (widget
                                                                              .videoModel
                                                                              .quality !=
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                          widget
                                                                              .videoModel
                                                                              .quality = 1;
                                                                          isQualityOpen =
                                                                              false;
                                                                          _controller!
                                                                              .dispose();
                                                                          _controller = VideoPlayerController.network(widget
                                                                              .videoModel
                                                                              .normal_quality_url!)
                                                                            ..initialize().then((_) {
                                                                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                              setState(() {
                                                                                _controller!.seekTo(widget.videoModel.currentDuration);
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
                                                                    child:
                                                                        Container(
                                                                      height: screenWidth *
                                                                          (widget.videoModel.quality == 1
                                                                              ? 0.025
                                                                              : 0.03),
                                                                      width: screenWidth *
                                                                          0.06,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              16)),
                                                                          color: Colors.white.withOpacity(widget.videoModel.quality == 1
                                                                              ? 0.3
                                                                              : 0)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '720',
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                            widget.videoModel
                                                                        .high_quality_url !=
                                                                    null
                                                                ? InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                                                    onTap: () {
                                                                      if (widget
                                                                              .videoModel
                                                                              .quality !=
                                                                          2) {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                          widget
                                                                              .videoModel
                                                                              .quality = 2;
                                                                          isQualityOpen =
                                                                              false;
                                                                          _controller!
                                                                              .dispose();
                                                                          _controller = VideoPlayerController.network(widget
                                                                              .videoModel
                                                                              .high_quality_url!)
                                                                            ..initialize().then((_) {
                                                                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                              setState(() {
                                                                                _controller!.seekTo(widget.videoModel.currentDuration);
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
                                                                    child:
                                                                        Container(
                                                                      height: screenWidth *
                                                                          (widget.videoModel.quality == 2
                                                                              ? 0.025
                                                                              : 0.03),
                                                                      width: screenWidth *
                                                                          0.06,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              16)),
                                                                          color: Colors.white.withOpacity(widget.videoModel.quality == 2
                                                                              ? 0.3
                                                                              : 0)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '1080',
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
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
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Image.asset(
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: ValueListenableBuilder(
                                    builder: (context, VideoPlayerValue value,
                                        child) {
                                      widget.videoModel.currentDuration =
                                          value.position;
                                      String positionSecond =
                                          (value.position.inSeconds % 60 > 9
                                              ? (value.position.inSeconds % 60)
                                                  .toString()
                                              : '0' +
                                                  (value.position.inSeconds %
                                                          60)
                                                      .toString());
                                      String durationSecond =
                                          (value.duration.inSeconds % 60 > 9
                                              ? (value.duration.inSeconds % 60)
                                                  .toString()
                                              : '0' +
                                                  (value.duration.inSeconds %
                                                          60)
                                                      .toString());

                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            '${value.position.inMinutes}:$positionSecond',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.88,
                                              child: ProgressBar(
                                                progress: value.position,
                                                buffered: value.duration,
                                                total: value.duration,
                                                progressBarColor: MyTheme
                                                    .instance
                                                    .colors
                                                    .colorSecondary,
                                                baseBarColor: Colors.white
                                                    .withOpacity(0.24),
                                                bufferedBarColor: MyTheme
                                                    .instance
                                                    .colors
                                                    .colorSecondary2,
                                                timeLabelLocation:
                                                    TimeLabelLocation.none,
                                                thumbColor: MyTheme.instance
                                                    .colors.colorSecondary
                                                    .withOpacity(0),
                                                barHeight: 3.0,
                                                thumbRadius: 5.0,
                                                onSeek: (duration) async {
                                                  _controller!.seekTo(duration);
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
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                        'assets/icons/download_video.png',
                                        width: 24,
                                        height: 24),
                                    InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                        onTap: () {
                                          changePlayerState();
                                        },
                                        child: Image.asset(
                                          isPlay
                                              ? 'assets/icons/pause.png'
                                              : 'assets/icons/play.png',
                                          height: screenHeight * 0.13,
                                        )),
                                    Image.asset('assets/icons/menu.png',
                                        width: 24, height: 24)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : MyCircleLoading(),
        ),
      ),
    );
  }

  void changePlayerState() {
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
    setState(() {
      isPlay = !isPlay;
    });
  }
}
