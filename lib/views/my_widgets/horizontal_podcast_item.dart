import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HorizontalPodcastItem extends StatefulWidget {
  late PodcastModel podcastModel;

  HorizontalPodcastItem(this.podcastModel);

  @override
  _HorizontalPodcastItemState createState() => _HorizontalPodcastItemState();
}

class _HorizontalPodcastItemState extends State<HorizontalPodcastItem> {
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
              imageUrl: widget.podcastModel.cover_photo_url!,
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
                  widget.podcastModel.title_en!.length > 14
                      ? widget.podcastModel.title_en!.substring(0, 14) + '...'
                      : widget.podcastModel.title_en!,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: screenWidth * 0.03, color: Colors.white),
                ),
                Visibility(
                  visible: false,
                  child: Image.asset(
                    'assets/icons/master_star.png',
                    width: 10,
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
            child: Text(
              widget.podcastModel.artist.name_en,
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
