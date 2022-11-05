import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/album/album_detail_list_screen.dart';
import 'package:ahanghaa/views/list/album_list_screen.dart';
import 'package:ahanghaa/views/list/song_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_album_item.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_song_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'horizontal_album_item_2.dart';

class TopLatestAlbum extends StatefulWidget {
  
  String title;
  String iconUrl;
  List<AlbumModel> albumList = [];

  TopLatestAlbum(this.albumList, this.title, this.iconUrl);

  @override
  _TopLatestAlbumState createState() => _TopLatestAlbumState();
}

class _TopLatestAlbumState extends State<TopLatestAlbum> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Container(
              width: screenWidth * 0.91,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        widget.iconUrl,
                        height: 18,
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
                              builder: (context) => AlbumListScreen(
                                  widget.title, widget.iconUrl)));
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: (widget.albumList.length > 3
                    ? widget.albumList.getRange(0, 3).toList()
                    : widget.albumList)
                .map((e) {
              return Expanded(
                flex: 1,
                child: InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      Navigator.push(
                          context,
                          SwipeablePageRoute(
                              settings: RouteSettings(name: 'main'),
                              builder: (context) =>
                                  AlbumDetailListScreenScreen(e)));
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: HorizontalAlbumItem2(e),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.08,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.2,
                                  height: screenWidth * 0.2,
                                  decoration: BoxDecoration(
                                      gradient: RadialGradient(colors: [
                                        MyTheme.instance.colors.colorSecondary,
                                        MyTheme.instance.colors.colorSecondary
                                            .withOpacity(0.0)
                                      ]),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Container(
                                      width: screenWidth * 0.1,
                                      height: screenWidth * 0.1,
                                      decoration: BoxDecoration(
                                          color: MyTheme
                                              .instance.colors.colorSecondary,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Image.asset(
                                            'assets/icons/mini_play.png',
                                            width: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    )),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
