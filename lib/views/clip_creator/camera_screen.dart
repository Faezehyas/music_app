import 'dart:io';

import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/clip_creator/video_generating_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CameraScreen extends StatefulWidget {
  File? audio;
  double? totalDuration;
  MusicModel musicModel = MusicModel();

  CameraScreen(this.audio, this.totalDuration, this.musicModel);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = true;
  late CameraController _cameraController;
  bool _isRecording = false;
  CameraLensDirection _cameraLensDirection = CameraLensDirection.front;
  double? _currentDuration = 0;

  @override
  void initState() {
    _initCamera(CameraLensDirection.front);
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    if (_isRecording) {
      _audioPlayer.stop();
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _audioPlayer.onAudioPositionChanged.listen((event) async {
      if (event.inSeconds >= (widget.totalDuration!.round() - 1) &&
          _isRecording) {
        await _recordVideo();
      }
      setState(() {
        _currentDuration = event.inSeconds.toDouble();
      });
    });

    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Visibility(
                        visible:
                            _cameraLensDirection == CameraLensDirection.back,
                        child: IconButton(
                            onPressed: () async {
                              if (_cameraController.value.flashMode ==
                                  FlashMode.off) {
                                await _cameraController
                                    .setFlashMode(FlashMode.torch);
                              } else {
                                await _cameraController
                                    .setFlashMode(FlashMode.off);
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              (_cameraController.value.flashMode ==
                                      FlashMode.torch)
                                  ? Icons.flash_off_outlined
                                  : Icons.flash_on_outlined,
                              color: Colors.white,
                              size: 34,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _isRecording
                          ? InkWell(
                              onTap: () async {
                                await _recordVideo();
                              },
                              child: SleekCircularSlider(
                                innerWidget: (value) => Center(
                                  child: Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                onChange: null,
                                appearance: CircularSliderAppearance(
                                  size: 56,
                                  customWidths: CustomSliderWidths(
                                      trackWidth: 2, progressBarWidth: 4),
                                  customColors: CustomSliderColors(
                                      dotColor: Colors.white,
                                      trackColor: Colors.white,
                                      progressBarColor: MyTheme
                                          .instance.colors.colorSecondary),
                                  startAngle: 180,
                                  angleRange: 360,
                                ),
                                min: 0,
                                max: widget.totalDuration!,
                                initialValue: _currentDuration!,
                              ),
                            )
                          : FloatingActionButton(
                              backgroundColor:
                                  MyTheme.instance.colors.colorSecondary,
                              child: Icon(
                                  _isRecording ? Icons.stop : Icons.circle),
                              onPressed: () async {
                                await _recordVideo();
                              },
                            ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Visibility(
                        visible: !_isRecording,
                        child: IconButton(
                            onPressed: () {
                              _cameraController.dispose();
                              _initCamera(_cameraLensDirection ==
                                      CameraLensDirection.front
                                  ? CameraLensDirection.back
                                  : CameraLensDirection.front);
                            },
                            icon: Icon(
                              Icons.camera_front_rounded,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _initCamera(direction) async {
    final cameras = await availableCameras();
    final front =
        cameras.firstWhere((camera) => camera.lensDirection == direction);
    _cameraController =
        CameraController(front, ResolutionPreset.max, enableAudio: true);
    await _cameraController.initialize();
    setState(() {
      _isLoading = false;
      _cameraLensDirection = direction;
    });
  }

  Future<void> _recordVideo() async {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
        _audioPlayer.stop();
      });
      final file = await _cameraController.stopVideoRecording();
      await watermark(file.path);
    } else {
      setState(() {
        _isRecording = true;
      });
      await _audioPlayer.play(widget.audio!.path,
          isLocal: true, stayAwake: true, respectSilence: true);
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
    }
  }

  Future<void> watermark(String filePath) async {
    final Directory dir = await getTemporaryDirectory();
    final outPath =
        "${dir.path}/${widget.musicModel.title_en!.replaceAll(' ', '_')}_${widget.musicModel.artists.singers.first.name_en.replaceAll(' ', '')}.mp4";
    final imagebyte = await rootBundle.load("assets/icons/watermark.png");
    final imgFile = await File('${dir.path}/watermark.png').writeAsBytes(
        imagebyte.buffer
            .asUint8List(imagebyte.offsetInBytes, imagebyte.lengthInBytes));
    Navigator.push(
        context,
        SwipeablePageRoute(
            settings: RouteSettings(name: 'main'),
            builder: (context) => VideoGeneratingScreen(
                  id: widget.musicModel.id,
                  title: widget.musicModel.title_en,
                  duration: widget.totalDuration!.round(),
                  audioOrVideoPath: filePath,
                  imgPath: imgFile.path,
                  outPath: outPath,
                  isWatermark: true,
                )));
  }
}
