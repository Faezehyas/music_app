import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerticalPlayListItemWithoutOption extends StatefulWidget {
  PlayListModel playListModel = new PlayListModel();
  bool isDeletePlaylist = false;
  VerticalPlayListItemWithoutOption(this.playListModel, this.isDeletePlaylist);

  @override
  _VerticalPlayListItemWithoutOptionState createState() =>
      _VerticalPlayListItemWithoutOptionState();
}

class _VerticalPlayListItemWithoutOptionState
    extends State<VerticalPlayListItemWithoutOption> {
  List<PopupMenuEntry<int>> menus = [];

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
                          flex: 10,
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
                                        widget.playListModel.name,
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
                            flex: 2,
                            child: Visibility(
                              visible: widget.isDeletePlaylist,
                              child: InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  mainProvider.restoreDeletedPlayList(context, widget.playListModel);
                                },
                                child: Icon(
                                  Icons.settings_backup_restore_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ))
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
