import 'dart:io';

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

class VerticalTopSongItem extends StatefulWidget {
  MusicModel musicModel = new MusicModel();
  int number;
  VerticalTopSongItem(this.musicModel, this.number);

  @override
  _VerticalTopSongItemState createState() => _VerticalTopSongItemState();
}

class _VerticalTopSongItemState extends State<VerticalTopSongItem> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return SizedBox(
        height: screenHeight * 0.12,
        child: SizedBox(
          height: screenHeight * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: const Color(0xff7c94b6),
                    image: (widget.musicModel.imgPath == null)
                        ? new DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.darken),
                            image: new NetworkImage(
                              widget.musicModel.cover_photo_url!,
                            ),
                          )
                        : new DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.darken),
                            image: new FileImage(
                                new File(widget.musicModel.imgPath!)),
                          ),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: (widget.musicModel.imgPath == null)
                                  ? Image.network(
                                      widget.musicModel.cover_photo_url!,
                                      width: screenHeight * 0.1,
                                      height: screenHeight * 0.1,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      new File(widget.musicModel.imgPath!),
                                      width: screenHeight * 0.1,
                                      height: screenHeight * 0.1,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            Column(
                              verticalDirection: VerticalDirection.up,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/mini_play.png',
                                      color: Colors.grey,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      (widget.musicModel.visitors)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.musicModel.title_en!.length < 30
                                          ? widget.musicModel.title_en!
                                          : widget.musicModel.title_en!
                                                  .substring(0, 30) +
                                              ' ...',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Visibility(
                                      visible: widget.musicModel
                                                  .master_quality_url !=
                                              null &&
                                          widget.musicModel.master_quality_url!
                                              .isNotEmpty,
                                      child: Image.asset(
                                        'assets/icons/master_star.png',
                                        width: 8,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.musicModel.artists.singers.first
                                                  .name_en.length <
                                              48
                                          ? widget.musicModel.artists.singers
                                              .first.name_en
                                          : widget.musicModel.artists.singers
                                                  .first.name_en
                                                  .substring(0, 48) +
                                              ' ...',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Visibility(
                                      visible: (widget.musicModel.artists
                                          .singers.first.is_verified),
                                      child: SizedBox(
                                          width: 8,
                                          height: 8,
                                          child: OfficialTick()),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ]),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '# ' + widget.number.toString(),
                              style: TextStyle(
                                  color: MyTheme.instance.colors.colorSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
