import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HorizontalVideoItem extends StatefulWidget {
  late VideoModel videoModel;

  HorizontalVideoItem(this.videoModel);

  @override
  _HorizontalVideoItemState createState() => _HorizontalVideoItemState();
}

class _HorizontalVideoItemState extends State<HorizontalVideoItem> {
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
            child: SizedBox(
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.videoModel.cover_photo_url!,
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    // progressIndicatorBuilder:
                    //     (context, url, downloadProgress) => Column(
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Column(
                    verticalDirection: VerticalDirection.up,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              'assets/icons/circle_play.png',
                              width: 20,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
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
                  widget.videoModel.title_en!.length > 14
                      ? widget.videoModel.title_en!.substring(0, 14) + '...'
                      : widget.videoModel.title_en!,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03, color: Colors.white),
                ),
                // Visibility(
                //   visible: widget.videoModel.master_quality_url != null &&
                //       widget.videoModel.master_quality_url!.isNotEmpty,
                //   child: Image.asset(
                //     'assets/icons/master_star.png',
                //     width: 10,
                //   ),
                // )
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          SizedBox(
            width: screenWidth * 0.25,
            child: Text(
              (widget.videoModel.artists.singers.length > 0
                              ? widget.videoModel.artists.singers.first.name_en
                              : '')
                          .length >
                      16
                  ? (widget.videoModel.artists.singers.length > 0
                          ? widget.videoModel.artists.singers.first.name_en
                          : '').substring(0,16) +
                      '...'
                  : (widget.videoModel.artists.singers.length > 0
                      ? widget.videoModel.artists.singers.first.name_en
                      : ''),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: screenWidth * 0.025, color: Colors.grey.shade400),
            ),
          )
        ],
      ),
    );
  }
}
