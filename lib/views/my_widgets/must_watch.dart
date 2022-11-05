import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/views/list/video_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_video_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_song_item.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_video_item.dart';
import 'package:ahanghaa/views/video/full_screen_video_player.dart';
import 'package:ahanghaa/views/video/mini_screen_video_player.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class MustWatch extends StatefulWidget {
  List<VideoModel> videoList = [];
  String title = '';

  MustWatch(this.videoList, this.title);

  @override
  _MustWatchState createState() => _MustWatchState();
}

class _MustWatchState extends State<MustWatch> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: widget.title != 'Videos'
              ? const EdgeInsets.fromLTRB(16, 0, 16, 8)
              : EdgeInsets.all(0),
          child: Container(
            width: screenWidth * 0.91,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.title != 'Videos'
                        ? Row(
                            children: [
                              Image.asset(
                                'assets/icons/circle_play.png',
                                width: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          )
                        : Container(),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    if (widget.title != 'Videos')
                      Navigator.push(
                          context,
                          SwipeablePageRoute(
                              builder: (context) => VideoListScreen(
                                  'New Video', 'assets/icons/video.png')));
                    else
                      Navigator.push(
                          context,
                          SwipeablePageRoute(
                              builder: (context) => WithoutTabVideoListScreen(
                                  widget.title,
                                  'assets/icons/play_circle_fill.png',
                                  widget.videoList)));
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: widget.title != 'Videos'
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: (widget.videoList.length > 3
                  ? widget.videoList.getRange(0, 3).toList()
                  : widget.videoList)
              .map((e) {
            return InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  context.read<PlayerProvider>().pauseAudio();
                  Navigator.push(
                      context,
                      SwipeablePageRoute(
                          builder: (context) => MiniScreenVideoPlayer(
                              widget.videoList,
                              widget.videoList.indexOf(e),
                              'New Video',
                              'assets/icons/video.png')));
                },
                child: HorizontalVideoItem(e));
          }).toList(),
        ),
      ],
    );
  }
}
