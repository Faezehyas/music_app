import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/show_popup.dart';
import 'package:ahanghaa/views/clip_creator/camera_screen.dart';
import 'package:ahanghaa/views/clip_creator/video_generating_screen.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CreateClipScreen extends StatefulWidget {
  MusicModel musicModel = MusicModel();
  CreateClipScreen(this.musicModel);

  @override
  State<CreateClipScreen> createState() => _CreateClipScreenState();
}

class _CreateClipScreenState extends State<CreateClipScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  bool isFirst = false;
  List<String> lengthTypes = ['15s', '30s', '60s', 'Custom'];
  String selectedLength = '15s';
  String startDurationStr = '0:00';
  String endDurationStr = '0:00';
  AudioPlayer audioPlayer = AudioPlayer();
  String cuttedAudioPath = '';
  bool isPlaying = false;
  ScreenshotController storyScreenshotController = ScreenshotController();
  ScreenshotController postScreenshotController = ScreenshotController();
  bool isLoading = false;
  String? generatedStoryPath;
  String? generatedPostPath;
  String postMood = 'LIGHT';
  List<double> _values = [0, 15];

  @override
  void initState() {
    _values = [0, 15];
    tabController = TabController(length: 2, vsync: this);
    calculateTimeStr();
    super.initState();
  }

  @override
  void dispose() {
    if (isPlaying) {
      audioPlayer.stop();
      audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirst && mounted && widget.musicModel.filePath == null) {
      isFirst = true;
      if (context
          .read<MainProvider>()
          .downloadedList
          .any((element) => element.id == widget.musicModel.id)) {
        setState(() {
          widget.musicModel = context
              .read<MainProvider>()
              .downloadedList
              .firstWhere((element) => element.id == widget.musicModel.id);
        });
      } else {
        Timer.periodic(Duration(milliseconds: 500), (timer) {
          if (widget.musicModel.filePath != null) {
            timer.cancel();
            Navigator.pop(context);
            setState(() {});
          }
        });
        showDownloading(context);
      }
    }
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.PLAYING;
      });
    });

    return Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
      return Scaffold(
        body: Stack(
          children: [
            postCover(),
            storyCover(),
            Container(
              height: 300,
              color: MyTheme.instance.colors.colorPrimary,
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: MyTheme.instance.colors.colorPrimary,
                ),
                Container(
                  width: screenWidth,
                  color: MyTheme.instance.colors.colorPrimary,
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
                            'Create Music Clip',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Icon(
                            Icons.slow_motion_video_rounded,
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
            Column(children: [
              if (widget.musicModel.imgPath != null) ...[
                SizedBox(
                  height: MediaQuery.of(context).padding.top +
                      (screenHeight * 0.06),
                ),
                TabBar(
                  controller: tabController,
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: MyTheme.instance.colors.colorSecondary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: 'Story',
                    ),
                    Tab(
                      text: 'Post',
                    ),
                    // Tab(
                    //   text: 'Camera',
                    // ),
                  ],
                ),
                Expanded(
                    child: TabBarView(controller: tabController, children: [
                  storyTab(context),
                  postTab(context),
                  // dubsmashTab(context)
                ]))
              ] else ...[
                Container(
                  height: screenHeight,
                  color: MyTheme.instance.colors.colorPrimary,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showDownloading(context);
                      },
                      child: Text(
                        '''Downloading "${widget.musicModel.title_en}" ...''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ]
            ]),
          ],
        ),
      );
    });
  }

  postCover() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Screenshot(
      controller: postScreenshotController,
      child: SizedBox(
        height: screenWidth,
        width: screenWidth,
        child: Stack(
          children: [
            Container(
              height: screenWidth,
              width: screenWidth,
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: new DecorationImage(
                    image: new NetworkImage(
                      widget.musicModel.cover_photo_url!,
                    ),
                    fit: BoxFit.cover,
                  )),
            ),
            BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                width: screenWidth,
                height: screenWidth,
                decoration:
                    new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  List<Widget>.generate((screenWidth / 4).round(), (index) {
                var h = Random().nextInt(40).toDouble();
                return Container(
                  width: 2,
                  height: h > 2 ? h : 3,
                  decoration: BoxDecoration(
                      color: postMood == 'LIGHT' ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                );
              }),
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        makeVideo(1);
                        // final Directory dir =
                        //     (await getExternalStorageDirectory())!;

                        // final file = File(( await postScreenshotController.captureAndSave(
                        //         dir.path,
                        //         fileName: 'output.png')) as String);

                        //         await GallerySaver.saveImage(file.path);
                      },
                      child: Container(
                        width: screenWidth * 0.6,
                        height: screenWidth * 0.6,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: NetworkImage(
                                    widget.musicModel.cover_photo_url!))),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.musicModel.title_en!,
                      style: TextStyle(
                          color:
                              postMood == 'LIGHT' ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.musicModel.artists.singers.first.name_en,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            postMood == 'LIGHT' ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Play on ahanghaa.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            postMood == 'LIGHT' ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  storyCover() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Screenshot(
      controller: storyScreenshotController,
      child: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new NetworkImage(
                widget.musicModel.cover_photo_url!,
              ),
              fit: BoxFit.cover,
            )),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                width: screenWidth * 0.7,
                height: screenWidth * 0.7,
                decoration:
                    new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Container(
                width: double.infinity,
                height: screenHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        MyTheme.data.primaryColor,
                        MyTheme.data.primaryColor.withOpacity(0.9),
                        MyTheme.data.primaryColor.withOpacity(0.7),
                        MyTheme.data.primaryColor.withOpacity(0.5),
                        MyTheme.data.primaryColor.withOpacity(0.3),
                        MyTheme.data.primaryColor.withOpacity(0.0)
                      ]),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: screenHeight * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.7,
                    height: screenWidth * 0.7,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.musicModel.cover_photo_url!))),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.musicModel.title_en!,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.musicModel.artists.singers.first.name_en,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Play on ahanghaa.com',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  dubsmashTab(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
      return Container(
        color: MyTheme.instance.colors.secondColorPrimary,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 24),
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: FileImage(File(widget.musicModel.imgPath!)))),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              widget.musicModel.title_en!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.musicModel.artists.singers.first.name_en,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'LENGTH',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes.first;
                    _values = [0, 15];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes.first ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes.first
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes.first,
                      style: TextStyle(
                          color: selectedLength == lengthTypes.first
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes[1];
                    _values = [0, 30];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes[1] ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes[1]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes[1],
                      style: TextStyle(
                          color: selectedLength == lengthTypes[1]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes[2];
                    _values = [0, 60];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes[2] ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes[2]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes[2],
                      style: TextStyle(
                          color: selectedLength == lengthTypes[2]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes.last;
                    _values = [
                      0,
                      playerProvider.totalDuration.inSeconds.toDouble()
                    ];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 60,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes.last ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes.last
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes.last,
                      style: TextStyle(
                          color: selectedLength == lengthTypes.last
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    startDurationStr,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Expanded(
                      child: FlutterSlider(
                    values: _values,
                    handlerHeight: 24,
                    handlerWidth: 24,
                    handler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            color: MyTheme.instance.colors.colorSecondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        )),
                    rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            color: MyTheme.instance.colors.colorSecondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        )),
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBar: BoxDecoration(
                          color: MyTheme.instance.colors.colorSecondary2),
                      activeTrackBar: BoxDecoration(
                          color: MyTheme.instance.colors.colorSecondary),
                    ),
                    rangeSlider: true,
                    max: playerProvider.totalDuration.inSeconds.toDouble(),
                    min: 0,
                    jump: false,
                    onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                      if (lengthTypes.last != selectedLength) {
                        var selectedTime = lengthTypes.first == selectedLength
                            ? 15
                            : lengthTypes[1] == selectedLength
                                ? 30
                                : lengthTypes[2] == selectedLength
                                    ? 60
                                    : playerProvider.totalDuration.inSeconds;
                        if (handlerIndex == 0) {
                          setState(() {
                            _values = [
                              lowerValue,
                              (lowerValue + selectedTime) >
                                      playerProvider.totalDuration.inSeconds
                                          .toDouble()
                                  ? playerProvider.totalDuration.inSeconds
                                      .toDouble()
                                  : (lowerValue + selectedTime)
                            ];
                          });
                        } else {
                          setState(() {
                            _values = [
                              (upperValue - selectedTime) < 0
                                  ? 0
                                  : (upperValue - selectedTime),
                              upperValue
                            ];
                          });
                        }
                      } else {
                        setState(() {
                          _values = [lowerValue, upperValue];
                        });
                      }
                      calculateTimeStr();
                    },
                  )),
                  Text(
                    endDurationStr,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      if (playerProvider.playerState.playing) {
                        playerProvider.pauseAudio();
                      }
                      if (!isPlaying) {
                        showLoading(context);
                        var ss = await cutAudio(widget.musicModel.filePath!,
                            _values.first, _values.last);
                        setState(() {
                          cuttedAudioPath = ss;
                        });
                        Navigator.pop(context);
                        setState(() {
                          isPlaying = true;
                          audioPlayer.play(
                              cuttedAudioPath.isEmpty
                                  ? widget.musicModel.filePath!
                                  : cuttedAudioPath,
                              isLocal: true);
                        });
                      } else {
                        setState(() {
                          isPlaying = false;
                          audioPlayer.stop();
                          audioPlayer.dispose();
                          audioPlayer = AudioPlayer();
                        });
                      }
                    },
                    child: Image.asset(
                      isPlaying
                          ? 'assets/icons/pause.png'
                          : 'assets/icons/play.png',
                      height: screenHeight * (isPlaying ? 0.085 : 0.06),
                    ))
              ],
            ),
            SizedBox(
              height: 36,
            ),
            SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    showLoading(context);
                    cuttedAudioPath = await cutAudio(
                        widget.musicModel.filePath!,
                        _values.first,
                        _values.last);
                    Navigator.pop(context);
                    if (isPlaying) {
                      audioPlayer.stop();
                      audioPlayer.dispose();
                    }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: 'main'),
                              builder: (context) => CameraScreen(
                                    File(cuttedAudioPath),
                                    _values.last - _values.first,
                                    widget.musicModel,
                                  )));
                    
                  },
                  child: !isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('Record'),
                        )
                      : SizedBox(
                          height: 8,
                          width: 52,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballBeat,
                            colors: [MyTheme.instance.colors.colorPrimary],
                          ),
                        ),
                )),
          ]),
        ),
      );
    });
  }

  postTab(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
      return Container(
        color: MyTheme.instance.colors.secondColorPrimary,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 24),
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: FileImage(File(widget.musicModel.imgPath!)))),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              widget.musicModel.title_en!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.musicModel.artists.singers.first.name_en,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'LENGTH',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes.first;
                    _values = [0, 15];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes.first ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes.first
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes.first,
                      style: TextStyle(
                          color: selectedLength == lengthTypes.first
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes[1];
                    _values = [0, 30];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes[1] ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes[1]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes[1],
                      style: TextStyle(
                          color: selectedLength == lengthTypes[1]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes[2];
                    _values = [0, 60];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes[2] ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes[2]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes[2],
                      style: TextStyle(
                          color: selectedLength == lengthTypes[2]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes.last;
                    _values = [
                      0,
                      playerProvider.totalDuration.inSeconds.toDouble()
                    ];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 60,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes.last ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes.last
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes.last,
                      style: TextStyle(
                          color: selectedLength == lengthTypes.last
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    startDurationStr,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Expanded(
                      child: FlutterSlider(
                    values: _values,
                    handlerHeight: 24,
                    handlerWidth: 24,
                    handler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            color: MyTheme.instance.colors.colorSecondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        )),
                    rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            color: MyTheme.instance.colors.colorSecondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        )),
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBar: BoxDecoration(
                          color: MyTheme.instance.colors.colorSecondary2),
                      activeTrackBar: BoxDecoration(
                          color: MyTheme.instance.colors.colorSecondary),
                    ),
                    rangeSlider: true,
                    max: playerProvider.totalDuration.inSeconds.toDouble(),
                    min: 0,
                    jump: false,
                    onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                      if (lengthTypes.last != selectedLength) {
                        var selectedTime = lengthTypes.first == selectedLength
                            ? 15
                            : lengthTypes[1] == selectedLength
                                ? 30
                                : lengthTypes[2] == selectedLength
                                    ? 60
                                    : playerProvider.totalDuration.inSeconds;
                        if (handlerIndex == 0) {
                          setState(() {
                            _values = [
                              lowerValue,
                              (lowerValue + selectedTime) >
                                      playerProvider.totalDuration.inSeconds
                                          .toDouble()
                                  ? playerProvider.totalDuration.inSeconds
                                      .toDouble()
                                  : (lowerValue + selectedTime)
                            ];
                          });
                        } else {
                          setState(() {
                            _values = [
                              (upperValue - selectedTime) < 0
                                  ? 0
                                  : (upperValue - selectedTime),
                              upperValue
                            ];
                          });
                        }
                      } else {
                        setState(() {
                          _values = [lowerValue, upperValue];
                        });
                      }
                      calculateTimeStr();
                    },
                  )),
                  Text(
                    endDurationStr,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      if (playerProvider.playerState.playing) {
                        playerProvider.pauseAudio();
                      }
                      if (!isPlaying) {
                        showLoading(context);
                        var ss = await cutAudio(widget.musicModel.filePath!,
                            _values.first, _values.last);
                        setState(() {
                          cuttedAudioPath = ss;
                        });
                        Navigator.pop(context);
                        setState(() {
                          isPlaying = true;
                          audioPlayer.play(
                              cuttedAudioPath.isEmpty
                                  ? widget.musicModel.filePath!
                                  : cuttedAudioPath,
                              isLocal: true);
                        });
                      } else {
                        setState(() {
                          isPlaying = false;
                          audioPlayer.stop();
                          audioPlayer.dispose();
                          audioPlayer = AudioPlayer();
                        });
                      }
                    },
                    child: Image.asset(
                      isPlaying
                          ? 'assets/icons/pause.png'
                          : 'assets/icons/play.png',
                      height: screenHeight * (isPlaying ? 0.085 : 0.06),
                    ))
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: (() {
                  setState(() {
                    postMood = 'LIGHT';
                  });
                }),
                child: Container(
                  width: 80,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color:
                          Colors.grey.withOpacity(postMood == 'LIGHT' ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: postMood == 'LIGHT'
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      'Light Mood',
                      style: TextStyle(
                          color: postMood == 'LIGHT'
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    postMood = 'DARK';
                  });
                }),
                child: Container(
                  width: 80,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color:
                          Colors.grey.withOpacity(postMood == 'DARK' ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: postMood == 'DARK'
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      'Dark Mood',
                      style: TextStyle(
                          color: postMood == 'DARK'
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 16,
            ),
            SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isLoading) {
                      makeVideo(1);
                    }
                  },
                  child: !isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('Generate'),
                        )
                      : SizedBox(
                          height: 8,
                          width: 52,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballBeat,
                            colors: [MyTheme.instance.colors.colorPrimary],
                          ),
                        ),
                )),
            SizedBox(
              height: 36,
            ),
          ]),
        ),
      );
    });
  }

  storyTab(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
      return Container(
        color: MyTheme.instance.colors.secondColorPrimary,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 24),
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: FileImage(File(widget.musicModel.imgPath!)))),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              widget.musicModel.title_en!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.musicModel.artists.singers.first.name_en,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'LENGTH',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes.first;
                    _values = [0, 15];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes.first ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes.first
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes.first,
                      style: TextStyle(
                          color: selectedLength == lengthTypes.first
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes[1];
                    _values = [0, 30];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes[1] ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes[1]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes[1],
                      style: TextStyle(
                          color: selectedLength == lengthTypes[1]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes[2];
                    _values = [0, 60];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 38,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes[2] ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes[2]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes[2],
                      style: TextStyle(
                          color: selectedLength == lengthTypes[2]
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    selectedLength = lengthTypes.last;
                    _values = [
                      0,
                      playerProvider.totalDuration.inSeconds.toDouble()
                    ];
                    calculateTimeStr();
                  });
                }),
                child: Container(
                  width: 60,
                  height: 28,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                          selectedLength == lengthTypes.last ? 0 : 1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: selectedLength == lengthTypes.last
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          width: 1)),
                  child: Center(
                    child: Text(
                      lengthTypes.last,
                      style: TextStyle(
                          color: selectedLength == lengthTypes.last
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    startDurationStr,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Expanded(
                      child: FlutterSlider(
                    values: _values,
                    handlerHeight: 24,
                    handlerWidth: 24,
                    handler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            color: MyTheme.instance.colors.colorSecondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        )),
                    rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            color: MyTheme.instance.colors.colorSecondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        )),
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBar: BoxDecoration(
                          color: MyTheme.instance.colors.colorSecondary2),
                      activeTrackBar: BoxDecoration(
                          color: MyTheme.instance.colors.colorSecondary),
                    ),
                    rangeSlider: true,
                    max: playerProvider.totalDuration.inSeconds.toDouble(),
                    min: 0,
                    jump: false,
                    onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                      if (lengthTypes.last != selectedLength) {
                        var selectedTime = lengthTypes.first == selectedLength
                            ? 15
                            : lengthTypes[1] == selectedLength
                                ? 30
                                : lengthTypes[2] == selectedLength
                                    ? 60
                                    : playerProvider.totalDuration.inSeconds;
                        if (handlerIndex == 0) {
                          setState(() {
                            _values = [
                              lowerValue,
                              (lowerValue + selectedTime) >
                                      playerProvider.totalDuration.inSeconds
                                          .toDouble()
                                  ? playerProvider.totalDuration.inSeconds
                                      .toDouble()
                                  : (lowerValue + selectedTime)
                            ];
                          });
                        } else {
                          setState(() {
                            _values = [
                              (upperValue - selectedTime) < 0
                                  ? 0
                                  : (upperValue - selectedTime),
                              upperValue
                            ];
                          });
                        }
                      } else {
                        setState(() {
                          _values = [lowerValue, upperValue];
                        });
                      }
                      calculateTimeStr();
                    },
                  )),
                  Text(
                    endDurationStr,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      if (playerProvider.playerState.playing) {
                        playerProvider.pauseAudio();
                      }
                      if (!isPlaying) {
                        showLoading(context);
                        var ss = await cutAudio(widget.musicModel.filePath!,
                            _values.first, _values.last);
                        setState(() {
                          cuttedAudioPath = ss;
                        });
                        Navigator.pop(context);
                        setState(() {
                          isPlaying = true;
                          audioPlayer.play(
                              cuttedAudioPath.isEmpty
                                  ? widget.musicModel.filePath!
                                  : cuttedAudioPath,
                              isLocal: true);
                        });
                      } else {
                        setState(() {
                          isPlaying = false;
                          audioPlayer.stop();
                          audioPlayer.dispose();
                          audioPlayer = AudioPlayer();
                        });
                      }
                    },
                    child: Image.asset(
                      isPlaying
                          ? 'assets/icons/pause.png'
                          : 'assets/icons/play.png',
                      height: screenHeight * (isPlaying ? 0.085 : 0.06),
                    ))
              ],
            ),
            SizedBox(
              height: 36,
            ),
            SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isLoading) {
                      makeVideo(0);
                    }
                  },
                  child: !isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('Generate'),
                        )
                      : SizedBox(
                          height: 8,
                          width: 52,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballBeat,
                            colors: [MyTheme.instance.colors.colorPrimary],
                          ),
                        ),
                )),
            SizedBox(
              height: 36,
            ),
          ]),
        ),
      );
    });
  }

  //0=> story & 1=> post
  makeVideo(int i) async {
    cuttedAudioPath = await cutAudio(
        widget.musicModel.filePath!, _values.first, _values.last);

    final Directory dir = (await getTemporaryDirectory());

    final imgPath = (i == 0
        ? await storyScreenshotController.captureAndSave(dir.path,
            fileName: 'output.png')
        : await postScreenshotController.captureAndSave(dir.path,
            fileName: 'output.png')) as String;
    Navigator.push(
        context,
        SwipeablePageRoute(
            settings: RouteSettings(name: 'main'),
            builder: (context) => VideoGeneratingScreen(
                  id: widget.musicModel.id,
                  title: widget.musicModel.title_en,
                  audioOrVideoPath: cuttedAudioPath,
                  duration: _values.last.round() - _values.first.round(),
                  imgPath: imgPath,
                  outPath:
                      '${dir.path}/${widget.musicModel.title_en!.replaceAll(' ', '_')}_${widget.musicModel.artists.singers.first.name_en.replaceAll(' ', '')}.mp4',
                )));
  }

  Future<String> cutAudio(String path, double start, double end) async {
    try {
      final Directory dir = await getTemporaryDirectory();
      final outPath = "${dir.path}/output.mp3";

      try {
        await File(outPath).delete();
      } catch (e) {}

      var cmd = "-i $path -ss $start -to $end -c copy $outPath";

      final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
      int rc = await _flutterFFmpeg.execute(cmd);
      if (rc == 0)
        return outPath;
      else
        return '';
    } catch (e) {
      return '';
    }
  }

  calculateTimeStr() {
    var endDuration = Duration(seconds: _values.last.round());
    var startDuration = Duration(seconds: _values.first.round());
    if (endDuration >= Duration(minutes: 10)) {
      endDurationStr = endDuration.toString().split('.').first.substring(2, 7);
    } else {
      endDurationStr = endDuration.toString().split('.').first.substring(3, 7);
    }
    if (startDuration >= Duration(minutes: 10)) {
      startDurationStr =
          startDuration.toString().split('.').first.substring(2, 7);
    } else {
      startDurationStr =
          startDuration.toString().split('.').first.substring(3, 7);
    }
  }

  showDownloading(context) {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      bool isAlertFirst = false;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: MyTheme.instance.colors.colorPrimary,
              content: Consumer<PlayerProvider>(
                  builder: (context, playerProvider, _) {
                if (!isAlertFirst &&
                    widget.musicModel.downloadedProgress == 0) {
                  isAlertFirst = true;
                  playerProvider.download(context, widget.musicModel,
                      canSave: false);
                }
                return StatefulBuilder(builder: (context, dialogSetState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 230,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                  infoProperties: InfoProperties(
                                      mainLabelStyle: TextStyle(
                                          color: MyTheme
                                              .instance.colors.colorSecondary,
                                          fontSize: 24)),
                                  customColors: CustomSliderColors(
                                      dotColor: Colors.white,
                                      trackColor: Colors.white,
                                      progressBarColor: MyTheme
                                          .instance.colors.colorSecondary)),
                              min: 0,
                              max: 100,
                              initialValue:
                                  widget.musicModel.downloadedProgress > 0
                                      ? (widget.musicModel.downloadedProgress /
                                              widget.musicModel.maxSize *
                                              100)
                                          .toDouble()
                                      : 0,
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Center(
                              child: Text(
                                '''Downloading "${widget.musicModel.title_en}" ...''',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
              }),
            );
          });
    });
  }
}
