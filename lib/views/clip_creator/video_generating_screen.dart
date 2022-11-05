import 'dart:io';

import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/clip_creator/video_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class VideoGeneratingScreen extends StatefulWidget {
  int? id;
  String? title;
  String? imgPath;
  String? audioOrVideoPath;
  String? outPath;
  int? duration;
  bool? isWatermark;
  VideoGeneratingScreen(
      {this.id,
      this.title,
      this.imgPath,
      this.audioOrVideoPath,
      this.duration,
      this.outPath,
      this.isWatermark});

  @override
  State<VideoGeneratingScreen> createState() => _VideoGeneratingScreenState();
}

class _VideoGeneratingScreenState extends State<VideoGeneratingScreen> {
  int generatingProgress = 1;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  void initState() {
    if (mounted) makeVideo();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) _flutterFFmpeg.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
                      'Generating ${widget.title} ...',
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
          Expanded(
              child: Container(
            color: MyTheme.instance.colors.secondColorPrimary,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        infoProperties: InfoProperties(
                            mainLabelStyle: TextStyle(
                                color: MyTheme.instance.colors.colorSecondary,
                                fontSize: 24)),
                        customColors: CustomSliderColors(
                            dotColor: Colors.white,
                            trackColor: Colors.white,
                            progressBarColor:
                                MyTheme.instance.colors.colorSecondary)),
                    min: 0,
                    max: 100,
                    initialValue: generatingProgress > 100
                        ? 100
                        : generatingProgress.toDouble(),
                  ),
                ),
                Text(
                  'It may take a long time, please wait',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )),
          GestureDetector(
            onTap: () {
              _flutterFFmpeg.cancel();
              Navigator.pop(context);
            },
            child: Container(
              color: MyTheme.instance.colors.colorSecondary,
              width: double.infinity,
              height: 56,
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //0=> story & 1=> post
  makeVideo() async {
    try {
      try {
        await File(widget.outPath!).delete();
      } catch (e) {}
      String commandToExecute = '';
      if (widget.isWatermark ?? false) {
        commandToExecute =
            '''-i ${widget.audioOrVideoPath} -i ${widget.imgPath} -filter_complex "overlay=x=(main_w-overlay_w):y=(main_h-overlay_h)" -codec:a copy ${widget.outPath}''';
      } else {
        commandToExecute =
            '-loop 1 -i ${widget.imgPath} -i ${widget.audioOrVideoPath} -y -vframes ${widget.duration! * 35} -r 35 -b 3500k -ab 384k -pix_fmt yuv420p ${widget.outPath}';
      }

      final FlutterFFmpegConfig _flutterFFmpegConfig =
          new FlutterFFmpegConfig();
      bool isFirst = false;
      _flutterFFmpegConfig.enableStatisticsCallback((statistics) {
        if (!isFirst) {
          isFirst = true;
        } else {
          setState(() {
            generatingProgress =
                ((statistics.time * 100) ~/ widget.duration!) ~/ 1000;
          });
        }
      });

      var res = await _flutterFFmpeg.execute(commandToExecute);
      if (res == 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: 'main'),
                builder: (context) => VideoPreviewScreen(
                      filePath: widget.outPath!,
                      id: widget.id!,
                    )));
      }
    } catch (e) {}
  }
}
