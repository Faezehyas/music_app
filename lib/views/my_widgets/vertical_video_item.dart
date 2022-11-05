import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class VerticalVideoItem extends StatefulWidget {
  VideoModel videoModel = new VideoModel();
  VerticalVideoItem(this.videoModel);
  @override
  _VerticalVideoItemState createState() => _VerticalVideoItemState();
}

class _VerticalVideoItemState extends State<VerticalVideoItem> {
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
                          flex: 16,
                          child: Row(children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.0005),
                                    child: Image.network(
                                      widget.videoModel.cover_photo_url!,
                                      width: screenHeight * 0.319,
                                      height: screenHeight * 0.079,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                      width: screenHeight * 0.32,
                                      height: screenHeight * 0.08,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                            MyTheme.instance.colors
                                                .secondColorPrimary,
                                            MyTheme.instance.colors
                                                .secondColorPrimary,
                                            MyTheme.instance.colors
                                                .secondColorPrimary,
                                            MyTheme.instance.colors
                                                .secondColorPrimary,
                                            MyTheme.instance.colors
                                                .secondColorPrimary,
                                            MyTheme.instance.colors
                                                .secondColorPrimary
                                                .withOpacity(0.9),
                                            MyTheme.instance.colors
                                                .secondColorPrimary
                                                .withOpacity(0.6),
                                            MyTheme.instance.colors
                                                .secondColorPrimary
                                                .withOpacity(0.3),
                                            MyTheme.instance.colors
                                                .secondColorPrimary
                                                .withOpacity(0)
                                          ],
                                              begin: Alignment.centerRight,
                                              end: Alignment.center))),
                                  SizedBox(
                                    width: screenHeight * 0.32,
                                    height: screenHeight * 0.08,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: screenHeight * 0.11,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            verticalDirection:
                                                VerticalDirection.up,
                                            children: [
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                  (widget.videoModel.title_en ??
                                                                  '')
                                                              .length >
                                                          12
                                                      ? (widget.videoModel
                                                                      .title_en ??
                                                                  '')
                                                              .substring(
                                                                  0, 12) +
                                                          '...'
                                                      : widget.videoModel
                                                              .title_en ??
                                                          '',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              Text(
                                                  (widget
                                                                  .videoModel
                                                                  .artists
                                                                  .singers
                                                                  .first
                                                                  .name_en)
                                                              .length >
                                                          14
                                                      ? (widget
                                                                  .videoModel
                                                                  .artists
                                                                  .singers
                                                                  .first
                                                                  .name_en)
                                                              .substring(
                                                                  0, 14) +
                                                          '...'
                                                      : widget
                                                          .videoModel
                                                          .artists
                                                          .singers
                                                          .first
                                                          .name_en,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  ShareVideoPicker(context, widget.videoModel);
                                },
                                child: Image.asset(
                                  'assets/icons/share.png',
                                  color: Colors.grey,
                                  width: 16,
                                ),
                              ),
                              PopupMenuButton<int>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  color: Colors.grey.shade300,
                                  onSelected: (index) {
                                    if (index == 0) {
                                      Navigator.push(
                                          context,
                                          SwipeablePageRoute(
                                              builder: (context) =>
                                                  ArtistDetailScreen(widget
                                                      .videoModel
                                                      .artists
                                                      .singers
                                                      .first
                                                      .id)));
                                    } else {
                                      mainProvider.changeVideoFavoriteState(
                                          context, widget.videoModel.id!);
                                      setState(() {
                                        if (widget.videoModel.is_favorited ??
                                            false)
                                          mainProvider.changeVideoFavoriteList(
                                              false, widget.videoModel);
                                        else
                                          mainProvider.changeVideoFavoriteList(
                                              true, widget.videoModel);
                                        widget.videoModel.is_favorited =
                                            !(widget.videoModel.is_favorited ??
                                                false);
                                      });
                                      ShowMessage(
                                          (widget.videoModel.is_favorited ??
                                                  false)
                                              ? 'Saved'
                                              : 'Remove from Saved',
                                          context);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                        PopupMenuItem<int>(
                                            value: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Go To Artist',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                        PopupMenuItem<int>(
                                            value: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  (widget.videoModel
                                                              .is_favorited ??
                                                          false)
                                                      ? 'Remove From Videos'
                                                      : 'Save To Videos',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ))
                                      ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
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
