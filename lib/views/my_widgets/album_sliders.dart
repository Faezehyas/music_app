import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/album/album_detail_list_screen.dart';
import 'package:ahanghaa/views/list/album_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_list_screen.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_album_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class AlbumSliders extends StatefulWidget {
  List<AlbumModel> albumList = [];

  AlbumSliders(this.albumList);

  @override
  _AlbumSlidersState createState() => _AlbumSlidersState();
}

class _AlbumSlidersState extends State<AlbumSliders> {
  var sliderIndex = 0;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: screenHeight * 0.3,
      color: MyTheme.instance.colors.secondColorPrimary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Container(
              width: screenWidth * 0.91,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/note_frame_1.png',
                        width: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Albums',
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
                              builder: (context) => AlbumListScreen(
                                  'Albums', 'assets/icons/note_frame_1.png')));
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.18,
            width: screenWidth,
            child: CarouselSlider(
              options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1.0,
                  aspectRatio: 1,
                  autoPlayInterval: const Duration(seconds: 10),
                  onPageChanged: (_index, _) {
                    setState(() {
                      sliderIndex = _index;
                    });
                  }),
              items: [0, 1, 2, 3, 4].map((e) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (widget.albumList.length >= ((e * 4) + 4)
                            ? widget.albumList.getRange(e * 4, ((e * 4) + 4))
                            : widget.albumList.getRange(0, 4))
                        .map((e) => InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SwipeablePageRoute(
                                      settings: RouteSettings(name: 'main'),
                                      builder: (context) =>
                                          AlbumDetailListScreenScreen(e)));
                            },
                            child: HorizontalAlbumItem(e)))
                        .toList(),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DotsIndicator(
                  dotsCount: 5,
                  axis: Axis.horizontal,
                  position: sliderIndex.toDouble(),
                  decorator: DotsDecorator(
                      activeColor: MyTheme.instance.colors.colorSecondary,
                      color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
