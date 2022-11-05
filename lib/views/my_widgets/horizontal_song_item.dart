import 'package:ahanghaa/models/music/music_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'offcial_tick.dart';

class HorizontalSongItem extends StatefulWidget {
  late MusicModel musicModel;

  HorizontalSongItem(this.musicModel);

  @override
  _HorizontalSongItemState createState() => _HorizontalSongItemState();
}

class _HorizontalSongItemState extends State<HorizontalSongItem> {
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
              imageUrl: widget.musicModel.cover_photo_url!,
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              // progressIndicatorBuilder: (context, url, downloadProgress) =>
              //     Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(
              //       height: 10,
              //       width: 60,
              //       child: LoadingIndicator(
              //         indicatorType: Indicator.ballBeat,
              //         colors: [MyTheme.instance.colors.colorSecondary],
              //       ),
              //     ),
              //   ],
              // ),
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
                  widget.musicModel.title_en!.length > 14
                      ? widget.musicModel.title_en!.substring(0, 14) + '...'
                      : widget.musicModel.title_en!,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03, color: Colors.white),
                ),
                Visibility(
                  visible: widget.musicModel.master_quality_url != null &&
                      widget.musicModel.master_quality_url!.isNotEmpty,
                  child: Image.asset(
                    'assets/icons/master_star.png',
                    width: 8,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          SizedBox(
            width: screenWidth * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.musicModel.artists.singers.length > 0
                      ? widget.musicModel.artists.singers.first.name_en
                                  .length >
                              16
                          ? widget.musicModel.artists.singers.first.name_en
                                  .substring(0, 16) +
                              '...'
                          : widget.musicModel.artists.singers.first.name_en
                      : '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: screenWidth * 0.025,
                      color: Colors.grey.shade400),
                ),
                Visibility(
                  visible: (widget.musicModel.artists.singers.length > 0 &&
                      widget.musicModel.artists.singers.first.is_verified),
                  child: SizedBox(width: 8, height: 8, child: OfficialTick()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

 }
