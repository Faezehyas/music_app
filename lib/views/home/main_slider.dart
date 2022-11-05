import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/my_widgets/offcial_tick.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MainSlider extends StatefulWidget {
  const MainSlider({Key? key}) : super(key: key);

  @override
  _MainSlider createState() => _MainSlider();
}

class _MainSlider extends State<MainSlider> {
  var sliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return mainProvider.slidersList.length > 0
          ? Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      aspectRatio: 1,
                      autoPlayInterval: const Duration(seconds: 6),
                      onPageChanged: (_index, _) {
                        setState(() {
                          sliderIndex = _index;
                        });
                      }),
                  items: mainProvider.slidersList.map((e) {
                    return InkWell(
                      highlightColor: Colors.transparent.withOpacity(0),
                      splashColor: Colors.transparent.withOpacity(0),
                      onTap: () async {
                        MusicModel musicModel = await mainProvider.getMusicById(
                            context, e.slidable_id);
                        if (playerProvider.currentList.length == 0 ||
                            playerProvider.currentList != [musicModel] ||
                            playerProvider
                                    .currentList[
                                        playerProvider.currentMusicIndex]
                                    .id !=
                                musicModel.id) playerProvider.clearAudio();
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 500),
                                settings: RouteSettings(name: 'main'),
                                child: PlayerScreen(
                                  currentList: [musicModel],
                                  currentMusicIndex: 0,
                                )));
                      },
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: e.cover_photo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Column(
                            verticalDirection: VerticalDirection.up,
                            children: [
                              Container(
                                width: double.infinity,
                                height: screenHeight * 0.35,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        MyTheme.data.primaryColor,
                                        MyTheme.data.primaryColor
                                            .withOpacity(0.9),
                                        MyTheme.data.primaryColor
                                            .withOpacity(0.4),
                                        MyTheme.data.primaryColor
                                            .withOpacity(0.0)
                                      ]),
                                ),
                                child: Column(
                                  verticalDirection: VerticalDirection.up,
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.04,
                                        ),
                                        Text(
                                          e.title.contains(' - ')
                                              ? e.title.split(' - ').first
                                              : e.title,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Visibility(
                                            visible: e.is_verified,
                                            child: const OfficialTick())
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.04,
                                        ),
                                        Text(
                                            (e.title.contains(' - ')
                                                            ? e.title
                                                                .split(' - ')
                                                                .last
                                                            : e.title)
                                                        .length >
                                                    25
                                                ? (e.title.contains(' - ')
                                                            ? e.title
                                                                .split(' - ')
                                                                .last
                                                            : e.title)
                                                        .substring(0, 25) +
                                                    '...'.toUpperCase()
                                                : (e.title.contains(' - ')
                                                    ? e.title.split(' - ').last
                                                    : e.title),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.08,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotsIndicator(
                      dotsCount: mainProvider.slidersList.length,
                      axis: Axis.horizontal,
                      position: sliderIndex.toDouble(),
                      decorator: DotsDecorator(
                          activeColor: MyTheme.instance.colors.colorSecondary,
                          color: Colors.grey),
                    )
                  ],
                )
              ],
            )
          : Container(
              height: screenHeight * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                    width: 60,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      colors: [MyTheme.instance.colors.colorSecondary],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
