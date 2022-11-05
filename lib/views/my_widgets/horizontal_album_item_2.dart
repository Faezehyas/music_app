import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HorizontalAlbumItem2 extends StatefulWidget {
  late AlbumModel albumModel;

  HorizontalAlbumItem2(this.albumModel);

  @override
  _HorizontalAlbumItem2State createState() => _HorizontalAlbumItem2State();
}

class _HorizontalAlbumItem2State extends State<HorizontalAlbumItem2> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.albumModel.cover_photo_url,
                width: screenWidth * 0.2,
                height: screenWidth * 0.35,
                fit: BoxFit.fitHeight,
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
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: screenWidth * 0.2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.albumModel.title_en.length > 10
                          ? widget.albumModel.title_en.substring(0, 10) + '...'
                          : widget.albumModel.title_en,
                      style: TextStyle(
                          fontSize: screenWidth * 0.03, color: Colors.white),
                    ),
                    Image.asset(
                      'assets/icons/note_frame_2.png',
                      width: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.albumModel.artist.name_en.length > 12
                          ? widget.albumModel.artist.name_en.substring(0, 12) +
                              '...'
                          : widget.albumModel.artist.name_en,
                      style: TextStyle(
                          fontSize: screenWidth * 0.025,
                          color: Colors.grey.shade400),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
