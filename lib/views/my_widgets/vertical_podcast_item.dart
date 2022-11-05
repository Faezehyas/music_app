import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/utils.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/play_list/add_to_play_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class VerticalPodcastItem extends StatefulWidget {
  PodcastModel podcastModel = new PodcastModel();
  bool? isFavorite;
  VerticalPodcastItem(this.podcastModel, this.isFavorite);

  @override
  _VerticalPodcastItemState createState() => _VerticalPodcastItemState();
}

class _VerticalPodcastItemState extends State<VerticalPodcastItem> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Visibility(
      visible: (widget.podcastModel.is_favorited ?? false) ||
          !(widget.isFavorite ?? false),
      child: Consumer2<MainProvider, PlayerProvider>(
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
                            flex: 12,
                            child: Row(children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: Image.network(
                                  widget.podcastModel.cover_photo_url!,
                                  width: screenHeight * 0.07,
                                  height: screenHeight * 0.07,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Column(
                                verticalDirection: VerticalDirection.up,
                                children: [
                                  Container(
                                    width: screenWidth * 0.3,
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.podcastModel.artist.name_en
                                                      .length <
                                                  24
                                              ? widget
                                                  .podcastModel.artist.name_en
                                              : widget.podcastModel.artist
                                                      .name_en
                                                      .substring(0, 24) +
                                                  ' ...',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    width: screenWidth * 0.3,
                                    child: Row(
                                      children: [
                                        Text(
                                          widget.podcastModel.title_en!.length <
                                                  14
                                              ? widget.podcastModel.title_en!
                                              : widget.podcastModel.title_en!
                                                      .substring(0, 14) +
                                                  ' ...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
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
                                Image.asset(
                                  'assets/icons/download.png',
                                  color: Colors.grey,
                                  width: 18,
                                ),
                                InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () {
                                    SharePodcastPicker(
                                        context, convertPodcastToMusic(widget.podcastModel));
                                  },
                                  child: Image.asset(
                                    'assets/icons/share.png',
                                    color: Colors.grey,
                                    width: 16,
                                  ),
                                ),
                                InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () {
                                    mainProvider.changePodcastFavoriteState(
                                        context, widget.podcastModel.id!);
                                    setState(() {
                                      widget.podcastModel.is_favorited =
                                          !(widget.podcastModel.is_favorited ??
                                              false);
                                    });
                                    ShowMessage(
                                        (widget.podcastModel.is_favorited ??
                                                false)
                                            ? 'Saved'
                                            : 'Remove from Saved',
                                        context);
                                  },
                                  child: Image.asset(
                                    'assets/icons/bookmark2.png',
                                    color: (widget.podcastModel.is_favorited ??
                                            false)
                                        ? MyTheme.instance.colors.colorSecondary
                                        : Colors.grey,
                                    height: 16,
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
                                      if (index == 1) {
                                        mainProvider.getUserPlayList(context);
                                        Navigator.push(
                                            context,
                                            SwipeablePageRoute(
                                                settings:
                                                    RouteSettings(name: 'main'),
                                                builder: (context) =>
                                                    AddToPlayListScreen(widget
                                                        .podcastModel.id!)));
                                      } else if (index == 0) {
                                        Navigator.push(
                                            context,
                                            SwipeablePageRoute(
                                                builder: (context) =>
                                                    ArtistDetailScreen(widget
                                                        .podcastModel
                                                        .artist
                                                        .id)));
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
                                                    'Add To PlayList',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )),
                                        ],
                                    child: Image.asset(
                                      'assets/icons/menu.png',
                                      color: Colors.grey,
                                      height: 16,
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
      }),
    );
  }
}
