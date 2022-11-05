import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/views/list/song_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_song_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class TopLatest extends StatefulWidget {
  String title;
  String iconUrl;
  List<MusicModel> musicList = [];

  TopLatest(this.musicList, this.title, this.iconUrl);

  @override
  _TopLatestState createState() => _TopLatestState();
}

class _TopLatestState extends State<TopLatest> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      widget.musicList.sort((b, a) => a.id!.compareTo(b.id!));
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              width: screenWidth * 0.91,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.iconUrl != ''
                          ? Row(
                              children: [
                                Image.asset(
                                  widget.iconUrl,
                                  height:
                                      widget.title == 'Latest Music' ? 24 : 16,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            )
                          : Container(),
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: widget.iconUrl != ''
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )
                    ],
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      if (widget.iconUrl != '')
                        Navigator.push(
                            context,
                            SwipeablePageRoute(
                                builder: (context) => SongListScreen(
                                    widget.title, widget.iconUrl)));
                      else
                        Navigator.push(
                            context,
                            SwipeablePageRoute(
                                builder: (context) => WithoutTabSongListScreen(
                                    widget.title, widget.musicList)));
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: (widget.musicList.length > 3
                    ? widget.musicList.getRange(0, 3).toList()
                    : widget.musicList)
                .map((e) {
              return InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    if (playerProvider.currentList.length == 0 ||
                        playerProvider.currentList != widget.musicList ||
                        playerProvider
                                .currentList[playerProvider.currentMusicIndex]
                                .id !=
                            e.id) playerProvider.clearAudio();
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            settings: RouteSettings(name: 'main'),
                            duration: Duration(milliseconds: 500),
                            child: PlayerScreen(
                                currentList: widget.iconUrl != ''
                                    ? mainProvider.latestMusicList
                                    : widget.musicList,
                                currentMusicIndex: widget.iconUrl != ''
                                    ? mainProvider.latestMusicList.indexOf(e)
                                    : widget.musicList.indexOf(e))));
                  },
                  child: HorizontalSongItem(e));
            }).toList(),
          ),
        ],
      );
    });
  }
}
