import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/show_popup.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/list/song_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_song_item.dart';
import 'package:ahanghaa/views/my_widgets/show_blur_bottom_sheet.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HorizontalSongsList extends StatefulWidget {
  List<MusicModel> musicList = [];
  String iconUrl = '';
  String title = '';

  HorizontalSongsList(
      {required this.musicList, required this.iconUrl, required this.title});

  @override
  _HorizontalSongsListState createState() => _HorizontalSongsListState();
}

class _HorizontalSongsListState extends State<HorizontalSongsList> {
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
                      width: 24,
                    ),
                    SizedBox(
                      width: 4,
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
                                SongListScreen(widget.title, widget.iconUrl)));
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
              children: (widget.musicList.length > 8
                      ? widget.musicList.getRange(0, 8).toList()
                      : widget.musicList)
                  .map((e) {
                return InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onLongPress: () {
                      showOptionMenu(context, e);
                    },
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
                                  currentList: widget.musicList,
                                  currentMusicIndex:
                                      widget.musicList.indexOf(e))));
                    },
                    child: HorizontalSongItem(e));
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  void showOptionMenu(BuildContext context, MusicModel musicModel) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    showBlurBottomSheet(context,
        StatefulBuilder(builder: (thisLowerContext, innerSetState) {
      return Consumer3<PlayerProvider, MainProvider, AuthProvider>(
          builder: (context, playerProvider, _mainProvider, _authProvider, _) {
        return Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 8),
                width: screenWidth * 0.3,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  Navigator.push(
                      context,
                      SwipeablePageRoute(
                          builder: (context) => ArtistDetailScreen(
                              musicModel.artists.singers.first.id)));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.mic_none_sharp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Go To Artist',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  if (_authProvider.isLogin) {
                    if (!_mainProvider.downloadedList
                        .any((element) => element.id == musicModel.id)) {
                      playerProvider.download(context, musicModel);
                      _mainProvider.insertIntoDownloadsList(musicModel);
                    }
                  } else {
                    Navigator.pop(context);
                    showGoToLoginDialog(context, _mainProvider);
                  }
                },
                child: Row(
                  children: [
                    Row(
                      children: [
                        musicModel.downloading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                      infoProperties: InfoProperties(
                                          mainLabelStyle: TextStyle(
                                              color: MyTheme.instance.colors
                                                  .colorSecondary
                                                  .withOpacity(0),
                                              fontSize: 8)),
                                      size: 24,
                                      customColors: CustomSliderColors(
                                          dotColor: Colors.white,
                                          trackColor: Colors.white,
                                          progressBarColor: MyTheme
                                              .instance.colors.colorSecondary)),
                                  min: 0,
                                  max: musicModel.maxSize.toDouble(),
                                  initialValue:
                                      musicModel.downloadedProgress.toDouble(),
                                ),
                              )
                            : Icon(
                                Icons.downloading_rounded,
                                color: _mainProvider.downloadedList.any(
                                        (element) =>
                                            element.id == musicModel.id)
                                    ? MyTheme.instance.colors.colorSecondary
                                    : Colors.white,
                              ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'Download',
                          style: TextStyle(
                              color: _mainProvider.downloadedList.any(
                                      (element) => element.id == musicModel.id)
                                  ? MyTheme.instance.colors.colorSecondary
                                  : Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () {
                  if (_authProvider.isLogin) {
                    _mainProvider.changeFavoriteState(context, musicModel.id!);
                    musicModel.is_favorited =
                        !(musicModel.is_favorited ?? false);
                    Navigator.pop(context);
                    ShowMessage(
                        (musicModel.is_favorited ?? false)
                            ? 'Saved'
                            : 'Remove from Saved',
                        context);
                  } else {
                    Navigator.pop(context);
                    showGoToLoginDialog(context, _mainProvider);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: (musicModel.is_favorited ?? false)
                          ? MyTheme.instance.colors.colorSecondary
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Save To Music',
                      style: TextStyle(
                          color: (musicModel.is_favorited ?? false)
                              ? MyTheme.instance.colors.colorSecondary
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent.withOpacity(0),
              splashColor: Colors.transparent.withOpacity(0),
              onTap: () {
                if (playerProvider
                    .currentList[playerProvider.currentMusicIndex].isPodcast)
                  SharePodcastPicker(context,playerProvider
                      .currentList[playerProvider.currentMusicIndex]);
                else
                  ShareMusicPicker(
                      context,
                      playerProvider
                          .currentList[playerProvider.currentMusicIndex]);
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      });
    }), () {});
  }
}
