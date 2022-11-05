import 'dart:io';

import 'package:ahanghaa/models/auth/profile_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/create_playlist_request_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/views/list/artist_list_screen.dart';
import 'package:ahanghaa/views/list/user_list_screen_with_list.dart';
import 'package:ahanghaa/views/list/without_tab_play_list_screen_with_list.dart';
import 'package:ahanghaa/views/my_widgets/circle_artist_item.dart';
import 'package:ahanghaa/views/my_widgets/my_circle_loading.dart';
import 'package:ahanghaa/views/play_list/play_list_detail_screen.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ProfileScreen extends StatefulWidget {
  String userName = '';
  bool isAuthTab = false;

  ProfileScreen(this.userName, this.isAuthTab);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int playlistMusicCount = 0;
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    MainProvider mainProvider = context.read<MainProvider>();
    if (mainProvider.adsModel.admob_android_id.isNotEmpty &&
        mainProvider.adsModel.admob_ios_id.isNotEmpty) {
      _ad = BannerAd(
          size: AdSize.banner,
          adUnitId: Platform.isAndroid
              ? mainProvider.adsModel.admob_android_id
              : mainProvider.adsModel.admob_ios_id,
          listener: BannerAdListener(onAdLoaded: (_) {
            setState(() {
              isAdLoaded = true;
            });
          }),
          request: AdRequest());
      _ad!.load();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_ad != null) {
      _ad!.dispose();
      isAdLoaded = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer2<MainProvider, AuthProvider>(
          builder: (context, mainProvider, authProvider, _) {
        return FutureBuilder<ProfileModel>(
            future: authProvider.getUserProfile(context, widget.userName),
            builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.data == null)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [MyCircleLoading()],
                );
              else {
                playlistMusicCount = 0;
                snapshot.data!.playlists.forEach((element) {
                  playlistMusicCount += element.music_count;
                });
                if (UserInfos.getString(context, 'username') == widget.userName)
                  authProvider.avatar = snapshot.data!.avatar;
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: MyTheme.instance.colors.secondColorPrimary,
                            height: screenHeight * 0.51,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).padding.top,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.06,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Visibility(
                                        visible: !widget.isAuthTab,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: InkWell(
                                            highlightColor: Colors.transparent
                                                .withOpacity(0),
                                            splashColor: Colors.transparent
                                                .withOpacity(0),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            ShareProfilePicker(widget.userName);
                                          },
                                          child: Image.asset(
                                            'assets/icons/share2.png',
                                            width: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.002,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            UserInfos.getString(context,
                                                            'username') ==
                                                        widget.userName &&
                                                    authProvider.avatar.isEmpty
                                                ? Container(
                                                    width: screenWidth * 0.25,
                                                    height: screenWidth * 0.25,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 2)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Image.asset(
                                                            'assets/icons/avatar2.png'),
                                                      ),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: SizedBox(
                                                      width: screenWidth * 0.25,
                                                      height:
                                                          screenWidth * 0.25,
                                                      child: Image.network(
                                                        UserInfos.getString(
                                                                    context,
                                                                    'username') ==
                                                                widget.userName
                                                            ? authProvider
                                                                .avatar
                                                            : snapshot
                                                                .data!.avatar,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: screenWidth * 0.04,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.username,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .radio_button_on_outlined,
                                                      size: 16,
                                                      color:
                                                          snapshot.data!
                                                                  .is_online
                                                              ? MyTheme
                                                                  .instance
                                                                  .colors
                                                                  .colorSecondary
                                                              : Colors.grey
                                                                  .shade800,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      snapshot.data!.is_online
                                                          ? 'online'
                                                          : 'offline',
                                                      style: TextStyle(
                                                          color: snapshot.data!
                                                                  .is_online
                                                              ? MyTheme
                                                                  .instance
                                                                  .colors
                                                                  .colorSecondary
                                                              : Colors.grey
                                                                  .shade800,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.04,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                highlightColor: Colors
                                                    .transparent
                                                    .withOpacity(0),
                                                splashColor: Colors.transparent
                                                    .withOpacity(0),
                                                onTap: () {
                                                  if (snapshot
                                                          .data!.listening.id !=
                                                      null) {
                                                    playMusic(
                                                        [
                                                          snapshot
                                                              .data!.listening
                                                        ],
                                                        snapshot
                                                            .data!.listening);
                                                  }
                                                },
                                                child: SizedBox(
                                                  height: screenHeight * 0.07,
                                                  child: Column(
                                                    verticalDirection:
                                                        VerticalDirection.up,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: screenHeight *
                                                            0.045,
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient: LinearGradient(
                                                                    colors: [
                                                                      snapshot.data!.listening.id !=
                                                                              null
                                                                          ? MyTheme
                                                                              .instance
                                                                              .colors
                                                                              .colorSecondary
                                                                              .withOpacity(
                                                                                  0.5)
                                                                          : Colors
                                                                              .grey
                                                                              .shade700,
                                                                      Colors
                                                                          .grey
                                                                          .shade100
                                                                          .withOpacity(
                                                                              0.5)
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerRight,
                                                                    end: Alignment
                                                                        .centerLeft),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              right: 8,
                                                              left:
                                                                  screenHeight *
                                                                      0.075),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment: snapshot
                                                                            .data!
                                                                            .listening
                                                                            .id !=
                                                                        null
                                                                    ? MainAxisAlignment
                                                                        .spaceEvenly
                                                                    : MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    snapshot.data!.listening.id !=
                                                                            null
                                                                        ? snapshot
                                                                            .data!
                                                                            .listening
                                                                            .title_en!
                                                                        : '--',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  Visibility(
                                                                    visible: snapshot
                                                                            .data!
                                                                            .listening
                                                                            .id !=
                                                                        null,
                                                                    child: Text(
                                                                        snapshot.data!.listening.id != null
                                                                            ? snapshot
                                                                                .data!.listening.artists.singers.first.name_en
                                                                            : '',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.white)),
                                                                  )
                                                                ],
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.07,
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            snapshot
                                                                        .data!
                                                                        .listening
                                                                        .id !=
                                                                    null
                                                                ? Container(
                                                                    width:
                                                                        screenHeight *
                                                                            0.06,
                                                                    height:
                                                                        screenHeight *
                                                                            0.06,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .white,
                                                                            width:
                                                                                1),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        image: DecorationImage(
                                                                            image:
                                                                                NetworkImage(snapshot.data!.listening.cover_photo_url!))),
                                                                  )
                                                                : Container(
                                                                    width:
                                                                        screenHeight *
                                                                            0.06,
                                                                    height:
                                                                        screenHeight *
                                                                            0.06,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .white,
                                                                            width:
                                                                                1),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        gradient: LinearGradient(
                                                                            colors: [
                                                                              Colors.black87,
                                                                              Colors.grey.shade700
                                                                            ],
                                                                            begin:
                                                                                Alignment.bottomCenter,
                                                                            end: Alignment.topCenter)),
                                                                  )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          'Is Listening Now',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: snapshot
                                                                          .data!
                                                                          .listening
                                                                          .id !=
                                                                      null
                                                                  ? MyTheme
                                                                      .instance
                                                                      .colors
                                                                      .colorSecondary
                                                                  : Colors
                                                                      .grey),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.04,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                if (snapshot.data!.playlists
                                                        .length >
                                                    0) {
                                                  Navigator.push(
                                                      context,
                                                      SwipeablePageRoute(
                                                          settings:
                                                              RouteSettings(
                                                                  name: 'main'),
                                                          builder: (context) =>
                                                              WithoutTabPlayListScreenWithList(
                                                                  'PlayLists',
                                                                  'assets/icons/note_2.png',
                                                                  snapshot.data!
                                                                      .playlists)));
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!.playlists.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Playlists',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                if (snapshot.data!.followers
                                                        .length >
                                                    0) {
                                                  Navigator.push(
                                                      context,
                                                      SwipeablePageRoute(
                                                          settings:
                                                              RouteSettings(
                                                                  name: 'main'),
                                                          builder: (context) =>
                                                              UserListScreenWithList(
                                                                  'Followers',
                                                                  snapshot.data!
                                                                      .followers)));
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!.followers.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Followers',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                if (snapshot.data!.followings
                                                        .length >
                                                    0) {
                                                  Navigator.push(
                                                      context,
                                                      SwipeablePageRoute(
                                                          settings:
                                                              RouteSettings(
                                                                  name: 'main'),
                                                          builder: (context) =>
                                                              UserListScreenWithList(
                                                                  'Following',
                                                                  snapshot.data!
                                                                      .followings)));
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!.followings.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Following',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                                if (isAdLoaded)
                                  Container(
                                    width: _ad!.size.width.toDouble(),
                                    height: _ad!.size.height.toDouble(),
                                    alignment: Alignment.center,
                                    child: AdWidget(
                                      ad: _ad!,
                                    ),
                                  ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      'Last 5 Tracks',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: screenHeight * 0.1,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: MyTheme
                                        .instance.colors.secondColorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [0, 1, 2, 3, 4]
                                        .map((e) => musicItemWidget(
                                            snapshot.data!.recentMusics, e))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                                snapshot.data!.artists.length > 0
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Artists',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                                InkWell(
                                                  highlightColor: Colors
                                                      .transparent
                                                      .withOpacity(0),
                                                  splashColor: Colors
                                                      .transparent
                                                      .withOpacity(0),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        SwipeablePageRoute(
                                                            settings:
                                                                RouteSettings(
                                                                    name:
                                                                        'main'),
                                                            builder: (context) =>
                                                                ArtistListScreen(
                                                                    'Artists',
                                                                    'assets/icons/artist_frame.png',
                                                                    snapshot
                                                                        .data!
                                                                        .artists)));
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            height: screenWidth * 0.32,
                                            child: GridView.count(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 4, 8, 0),
                                              crossAxisCount: 3,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: List.generate(
                                                  (snapshot.data!.artists
                                                                  .length >
                                                              3
                                                          ? snapshot
                                                              .data!.artists
                                                              .getRange(0, 3)
                                                          : snapshot
                                                              .data!.artists)
                                                      .length, (index) {
                                                return InkWell(
                                                    highlightColor: Colors
                                                        .transparent
                                                        .withOpacity(0),
                                                    splashColor: Colors
                                                        .transparent
                                                        .withOpacity(0),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          SwipeablePageRoute(
                                                              builder: (context) =>
                                                                  ArtistListScreen(
                                                                      'Artists',
                                                                      'assets/icons/artist_frame.png',
                                                                      snapshot
                                                                          .data!
                                                                          .artists)));
                                                    },
                                                    child: CircleArtistItem(
                                                        snapshot.data!
                                                            .artists[index]));
                                              }),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.04,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                (snapshot.data!.playlists.length > 0)
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'playlists',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  '$playlistMusicCount Tracks',
                                                  style: TextStyle(
                                                      color: MyTheme
                                                          .instance
                                                          .colors
                                                          .colorSecondary,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Container(
                                              height: 1,
                                              width: double.infinity,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight *
                                                ((snapshot.data!.playlists
                                                                .length /
                                                            3)
                                                        .ceil() *
                                                    0.16),
                                            child: GridView.count(
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 4, 8, 0),
                                                crossAxisCount: 3,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: List.generate(
                                                    snapshot.data!.playlists
                                                        .length, (index) {
                                                  return playListItemWidget(
                                                      snapshot.data!.playlists,
                                                      index);
                                                })),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: screenHeight * 0.07,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight,
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.49,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () async {
                                    if (widget.isAuthTab) {
                                      authProvider.changeProfileScreen(
                                          ProfileScreenStateEnum.Setting);
                                    } else {
                                      await authProvider.changeUserFollowing(
                                          context, widget.userName);
                                      setState(() {
                                        if (snapshot.data!.followers.any(
                                            (element) =>
                                                element.username ==
                                                UserInfos.getString(
                                                    context, 'username'))) {
                                          snapshot.data!.followers.removeWhere(
                                              (element) =>
                                                  element.username ==
                                                  UserInfos.getString(
                                                      context, 'username'));
                                        } else {
                                          UserModel userModel = new UserModel();
                                          userModel.name = snapshot.data!.name;
                                          userModel.username =
                                              snapshot.data!.username;
                                          userModel.avatar =
                                              snapshot.data!.avatar;
                                          snapshot.data!.followers
                                              .add(userModel);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: screenWidth * 0.35,
                                    height: screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (widget.isAuthTab ||
                                                !snapshot.data!.followers.any(
                                                    (element) =>
                                                        element.username ==
                                                        UserInfos.getString(
                                                            context,
                                                            'username')))
                                            ? MyTheme
                                                .instance.colors.colorSecondary
                                            : Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                            visible: !widget.isAuthTab &&
                                                !snapshot.data!.followers.any(
                                                    (element) =>
                                                        element.username ==
                                                        UserInfos.getString(
                                                            context,
                                                            'username')),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Icon(
                                                Icons.done_rounded,
                                                color: MyTheme.instance.colors
                                                    .colorPrimary,
                                                size: 20,
                                              ),
                                            )),
                                        Text(
                                          widget.isAuthTab
                                              ? 'Edit Profile'
                                              : snapshot.data!.followers.any(
                                                      (element) =>
                                                          element.username ==
                                                          UserInfos.getString(
                                                              context,
                                                              'username'))
                                                  ? 'Following'
                                                  : 'Follow',
                                          style: TextStyle(
                                              color: MyTheme
                                                  .instance.colors.colorPrimary,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            });
      }),
    );
  }

  Widget playListItemWidget(List<PlayListModel> playlists, int index) =>
      InkWell(
          highlightColor: Colors.transparent.withOpacity(0),
          splashColor: Colors.transparent.withOpacity(0),
          onTap: () {
            Navigator.push(
                context,
                SwipeablePageRoute(
                    settings: RouteSettings(name: 'main'),
                    builder: (context) =>
                        PlayListDetailScreen(playlists[index], false)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Image.asset('assets/icons/playlist_folder.png'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 54,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              playlists[index].cover_photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                playlists[index].name.length > 9
                                    ? playlists[index].name.substring(0, 9) +
                                        '...'
                                    : playlists[index].name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        MyTheme.instance.colors.colorPrimary),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  ((UserInfos.getString(context, 'username') ??
                                              '') !=
                                          widget.userName)
                                      ? EdgeInsets.only(bottom: 6)
                                      : EdgeInsets.only(bottom: 2),
                              child: ((UserInfos.getString(
                                              context, 'username') ??
                                          '') !=
                                      widget.userName)
                                  ? Image.asset(
                                      'assets/icons/note.png',
                                      color:
                                          MyTheme.instance.colors.colorPrimary,
                                      width: 12,
                                    )
                                  : InkWell(
                                      highlightColor:
                                          Colors.transparent.withOpacity(0),
                                      splashColor:
                                          Colors.transparent.withOpacity(0),
                                      onTap: () {
                                        CreatePlaylistRequestModel
                                            requestModel =
                                            CreatePlaylistRequestModel();
                                        requestModel.name =
                                            playlists[index].name;
                                        requestModel.is_visible =
                                            !playlists[index].is_visible;
                                        context
                                            .read<MainProvider>()
                                            .updatePlayList(
                                                context,
                                                requestModel,
                                                playlists[index].id)
                                            .then((value) => {
                                                  if (value.id > 0)
                                                    {playlists[index] = value}
                                                });
                                      },
                                      child: Icon(playlists[index].is_visible
                                          ? Icons.remove_red_eye
                                          : Icons.visibility_off_rounded),
                                    ),
                            ),
                            SizedBox(
                              width:
                                  ((UserInfos.getString(context, 'username') ??
                                              '') !=
                                          widget.userName)
                                      ? 20
                                      : 16,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ));

  Widget musicItemWidget(List<MusicModel> musicList, int index) => InkWell(
        highlightColor: Colors.transparent.withOpacity(0),
        splashColor: Colors.transparent.withOpacity(0),
        onTap: () {
          playMusic(musicList, musicList[index]);
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: musicList.length - 1 >= index
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      musicList[index].cover_photo_url!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15),
        ),
      );

  playMusic(List<MusicModel> musicList, MusicModel e) {
    PlayerProvider playerProvider = context.read<PlayerProvider>();
    if (playerProvider.currentList.length == 0 ||
        playerProvider.currentList != musicList ||
        playerProvider.currentList[playerProvider.currentMusicIndex].id != e.id)
      playerProvider.clearAudio();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: Duration(milliseconds: 500),
            settings: RouteSettings(name: 'main'),
            child: PlayerScreen(
                currentList: musicList,
                currentMusicIndex: musicList.indexOf(e))));
  }
}
