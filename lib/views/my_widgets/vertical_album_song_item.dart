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
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'offcial_tick.dart';

class VerticalAlbumSongItem extends StatefulWidget {
  MusicModel musicModel = new MusicModel();
  int number = 0;
  VerticalAlbumSongItem(this.musicModel, this.number);

  @override
  _VerticalAlbumSongItemState createState() => _VerticalAlbumSongItemState();
}

class _VerticalAlbumSongItemState extends State<VerticalAlbumSongItem> {
  List<PopupMenuEntry<int>> menus = [];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      menus = [
        PopupMenuItem<int>(
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Go To Artist',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )),
        PopupMenuItem<int>(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add To PlayList',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ))
      ];
      return SizedBox(
        height: screenHeight * 0.08,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            SizedBox(
              height: screenHeight * 0.08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 12,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      widget.number.toString() + '.  ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  verticalDirection: VerticalDirection.up,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.musicModel.artists.singers
                                                      .first.name_en.length <
                                                  40
                                              ? widget.musicModel.artists
                                                  .singers.first.name_en
                                              : widget.musicModel.artists
                                                      .singers.first.name_en
                                                      .substring(0, 40) +
                                                  ' ...',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
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
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.musicModel.title_en!.length <
                                                  25
                                              ? widget.musicModel.title_en!
                                              : widget.musicModel.title_en!
                                                      .substring(0, 25) +
                                                  ' ...',
                                          style: TextStyle(
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
                                              widget
                                                  .musicModel
                                                  .master_quality_url!
                                                  .isNotEmpty,
                                          child: Image.asset(
                                            'assets/icons/master_star.png',
                                            width: 8,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ]),
                        ),
                        Expanded(
                          flex: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  if (!mainProvider.downloadedList.any(
                                      (element) =>
                                          element.id == widget.musicModel.id)) {
                                    playerProvider.download(
                                        context, widget.musicModel);
                                    mainProvider.insertIntoDownloadsList(
                                        widget.musicModel);
                                  } else {
                                    DataBaseProvider dataBaseProvider =
                                        new DataBaseProvider();
                                    dataBaseProvider.deleteDownloaded(
                                        widget.musicModel.id!);
                                    mainProvider.deleteDownloaded(
                                        widget.musicModel.id!);
                                  }
                                },
                                child: widget.musicModel.downloading
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: SleekCircularSlider(
                                            appearance: CircularSliderAppearance(
                                                infoProperties: InfoProperties(
                                                    mainLabelStyle: TextStyle(
                                                        color: MyTheme
                                                            .instance
                                                            .colors
                                                            .colorSecondary
                                                            .withOpacity(0),
                                                        fontSize: 8)),
                                                size: 20,
                                                customColors: CustomSliderColors(
                                                    dotColor: Colors.white,
                                                    trackColor: Colors.white,
                                                    progressBarColor: MyTheme
                                                        .instance
                                                        .colors
                                                        .colorSecondary)),
                                            min: 0,
                                            max: widget.musicModel.maxSize
                                                .toDouble(),
                                            initialValue: widget
                                                .musicModel.downloadedProgress
                                                .toDouble(),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Image.asset(
                                          'assets/icons/download.png',
                                          color: mainProvider.downloadedList
                                                  .any((element) =>
                                                      element.id ==
                                                      widget.musicModel.id)
                                              ? MyTheme.instance.colors
                                                  .colorSecondary
                                              : Colors.grey,
                                          width: 16,
                                        ),
                                      ),
                              ),
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  ShareMusicPicker(
                                      context,
                                      playerProvider.currentList[
                                          playerProvider.currentMusicIndex]);
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
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  mainProvider.changeFavoriteState(
                                      context, widget.musicModel.id!);
                                  setState(() {
                                    widget.musicModel.is_favorited =
                                        !(widget.musicModel.is_favorited ??
                                            false);
                                  });
                                  ShowMessage(
                                      (widget.musicModel.is_favorited ?? false)
                                          ? 'Saved'
                                          : 'Remove from Saved',
                                      context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Image.asset(
                                    'assets/icons/bookmark2.png',
                                    color: (widget.musicModel.is_favorited ??
                                            false)
                                        ? MyTheme.instance.colors.colorSecondary
                                        : Colors.grey,
                                    height: 16,
                                  ),
                                ),
                              ),
                              PopupMenuButton<int>(
                                  onSelected: (index) {
                                    if (index == 1) {
                                      mainProvider.getUserPlayList(context);
                                      Navigator.push(
                                          context,
                                          SwipeablePageRoute(
                                              settings:
                                                  RouteSettings(name: 'main'),
                                              builder: (context) =>
                                                  AddToPlayListScreen(
                                                      widget.musicModel.id!)));
                                    } else if (index == 0) {
                                      Navigator.push(
                                          context,
                                          SwipeablePageRoute(
                                              settings:
                                                  RouteSettings(name: 'main'),
                                              builder: (context) =>
                                                  ArtistDetailScreen(widget
                                                      .musicModel
                                                      .artists
                                                      .singers
                                                      .first
                                                      .id)));
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  color: Colors.grey.shade300,
                                  itemBuilder: (context) => menus,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Image.asset(
                                      'assets/icons/menu.png',
                                      color: Colors.grey,
                                      height: 16,
                                    ),
                                  ))
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
