import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerticalPlayListItem extends StatefulWidget {
  PlayListModel playListModel = new PlayListModel();
  bool isMyPlayList = false;
  VerticalPlayListItem(this.playListModel, this.isMyPlayList);

  @override
  _VerticalPlayListItemState createState() => _VerticalPlayListItemState();
}

class _VerticalPlayListItemState extends State<VerticalPlayListItem> {
  List<PopupMenuEntry<int>> menus = [];

  @override
  void initState() {
    if (widget.isMyPlayList) {
      menus = [
        PopupMenuItem<int>(
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Remove PlayList',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ))
      ];
    }
    super.initState();
  }

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
                          flex: 12,
                          child: Row(children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: Image.network(
                                widget.playListModel.cover_photo,
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
                                        widget.playListModel.music_count > 0
                                            ? (widget.playListModel.music_count
                                                    .toString() +
                                                ' Songs')
                                            : '0 Songs',
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
                                        widget.playListModel.name.length < 12
                                            ? widget.playListModel.name
                                            : widget.playListModel.name
                                                    .substring(0, 12) +
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
                          flex: widget.isMyPlayList ? 4 : 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  if (widget.isMyPlayList)
                                    ShareUserPlayListPicker(
                                        context, widget.playListModel);
                                  else
                                    SharePlayListPicker(
                                        context, widget.playListModel);
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
                              !widget.isMyPlayList
                                  ? InkWell(
                                      highlightColor:
                                          Colors.transparent.withOpacity(0),
                                      splashColor:
                                          Colors.transparent.withOpacity(0),
                                      onTap: () {
                                        mainProvider
                                            .changePlayListFavoriteState(
                                                context, widget.playListModel);
                                        setState(() {
                                          widget.playListModel.is_favorited =
                                              !widget
                                                  .playListModel.is_favorited;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Image.asset(
                                          'assets/icons/bookmark2.png',
                                          color: (widget
                                                  .playListModel.is_favorited)
                                              ? MyTheme.instance.colors
                                                  .colorSecondary
                                              : Colors.grey,
                                          height: 16,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              PopupMenuButton<int>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  color: Colors.grey.shade300,
                                  onSelected: (index) {
                                    mainProvider.deletePlayList(
                                        context, widget.playListModel);
                                  },
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
