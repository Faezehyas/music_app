import 'dart:io';

import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/play_list/add_to_play_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'offcial_tick.dart';

class VerticalAlbumItem extends StatefulWidget {
  AlbumModel albumModel = new AlbumModel();
  VerticalAlbumItem(this.albumModel);

  @override
  _VerticalAlbumItemState createState() => _VerticalAlbumItemState();
}

class _VerticalAlbumItemState extends State<VerticalAlbumItem> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return SizedBox(
        height: screenHeight * 0.111,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Row(children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: Image.network(
                                widget.albumModel.cover_photo_url,
                                width: screenHeight * 0.07,
                                height: screenHeight * 0.07,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              verticalDirection: VerticalDirection.up,
                              children: [
                                Container(
                                  width: screenWidth * 0.3,
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.albumModel.artist.name_en,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Visibility(
                                        visible: (widget
                                            .albumModel.artist.is_verified),
                                        child: SizedBox(
                                            width: 8,
                                            height: 8,
                                            child: OfficialTick()),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.albumModel.title_en,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ]),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  mainProvider.changeAlbumFavoriteState(
                                      context, widget.albumModel);
                                  setState(() {
                                    widget.albumModel.is_favorited =
                                        !widget.albumModel.is_favorited;
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Image.asset(
                                    'assets/icons/bookmark2.png',
                                    color: (widget.albumModel.is_favorited)
                                        ? MyTheme.instance.colors.colorSecondary
                                        : Colors.grey,
                                    height: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  ShareAlbumPicker(context, widget.albumModel);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Image.asset(
                                    'assets/icons/share.png',
                                    color: Colors.grey,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
