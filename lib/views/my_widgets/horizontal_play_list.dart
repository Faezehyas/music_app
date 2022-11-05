import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/views/list/song_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_play_list_item.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_song_item.dart';
import 'package:ahanghaa/views/play_list/play_list_detail_screen.dart';
import 'package:ahanghaa/views/list/play_list_screen.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HorizontalPlayList extends StatefulWidget {
  List<PlayListModel> playList = [];
  String iconUrl = '';
  String title = '';

  HorizontalPlayList(
      {required this.playList, required this.iconUrl, required this.title});

  @override
  _HorizontalPlayListState createState() => _HorizontalPlayListState();
}

class _HorizontalPlayListState extends State<HorizontalPlayList> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      widget.iconUrl,
                      width: 20,
                    ),
                    SizedBox(
                      width: 12,
                    ),
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
                    Navigator.push(
                        context,
                        SwipeablePageRoute(
                            builder: (context) =>
                                PlayListScreen(widget.title, widget.iconUrl)));
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.2,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (widget.playList.length > 8
                      ? widget.playList.getRange(0, 8).toList()
                      : widget.playList)
                  .map((e) {
                return InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      Navigator.push(
                          context,
                          SwipeablePageRoute(
                              settings: RouteSettings(name: 'main'),
                              builder: (context) =>
                                  PlayListDetailScreen(e, false)));
                    },
                    child: HorizontalPlayListItem(e));
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}
