import 'dart:io';
import 'dart:typed_data';

import 'package:ahanghaa/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String filePath;
  final int id;

  const VideoPreviewScreen({Key? key, required this.filePath, required this.id})
      : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.filePath),
    );
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white)),
              child: Center(
                child: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () async {
              File outFile = File(widget.filePath);
              await GallerySaver.saveVideo(outFile.path);
              ShowMessage('Saved', context);
            },
          ),
          IconButton(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white)),
              child: Center(
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {
              Uint8List bytes = File(widget.filePath).readAsBytesSync();
              ShareFilesAndScreenshotWidgets().shareFile(
                  "Ahanghaa", 'dubsmash.mp4', bytes, "video/mp4",
                  text: 'https://www.ahanghaa.com/tracks/${widget.id}');
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                    width: _videoPlayerController.value.size.width,
                    height: _videoPlayerController.value.size.height,
                    child: VideoPlayer(_videoPlayerController)),
              ),
            );
          }
        },
      ),
    );
  }
}
