import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'offcial_tick.dart';

class HorizontalPlayListItem extends StatefulWidget {
  late PlayListModel playListModel;

  HorizontalPlayListItem(this.playListModel);

  @override
  _HorizontalPlayListItemState createState() => _HorizontalPlayListItemState();
}

class _HorizontalPlayListItemState extends State<HorizontalPlayListItem> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: widget.playListModel.cover_photo,
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: screenWidth * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.playListModel.name.length > 12
                      ? widget.playListModel.name.substring(0, 12) + '...'
                      : widget.playListModel.name,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
