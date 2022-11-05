import 'dart:async';
import 'dart:io';
import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/models/genres&mood/genre_model.dart';
import 'package:ahanghaa/models/music/music_details_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/search/search_all_response_model.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/show_popup.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/utils/utils.dart';
import 'package:ahanghaa/views/artist/artist_detail_screen.dart';
import 'package:ahanghaa/views/auth/profile_screen.dart';
import 'package:ahanghaa/views/list/artist_list_screen.dart';
import 'package:ahanghaa/views/list/top_charts_song_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_album_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_list_screen.dart';
import 'package:ahanghaa/views/list/without_tab_list_screen_with_paging_screen.dart';
import 'package:ahanghaa/views/my_widgets/circle_artist_item.dart';
import 'package:ahanghaa/views/my_widgets/horizontal_album_item.dart';
import 'package:ahanghaa/views/my_widgets/must_watch.dart';
import 'package:ahanghaa/views/my_widgets/search_filter_item.dart';
import 'package:ahanghaa/views/my_widgets/top_latest.dart';
import 'package:ahanghaa/views/my_widgets/vertical_album_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_podcast_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_song_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_user_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_video_item.dart';
import 'package:ahanghaa/views/player/player_screen.dart';
import 'package:ahanghaa/views/video/mini_screen_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  Timer? _timer;
  SearchAllResponseModel searchAllResponseModel = new SearchAllResponseModel();
  String lastKeyword = '';
  var searchControler = new TextEditingController();
  List<GenreAndMoodeModel> genreList = [];
  List<GenreAndMoodeModel> moodsList = [];
  bool isLoaded = false;
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
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
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer3<MainProvider, PlayerProvider, DataBaseProvider>(
        builder: (context, mainProvider, playerProvider, dataBaseProvider, _) {
      _mainProvider = mainProvider;
      mainProvider.getGenresList(context).then((value) {
        setState(() {
          genreList = value;
        });
      });
      mainProvider.getMoodsList(context).then((value) {
        setState(() {
          moodsList = value;
        });
      });
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: screenWidth * 0.9,
                      child: TypeAheadFormField(
                          hideOnEmpty: true,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: searchControler,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            onChanged: (newValue) {
                              search(newValue);
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white.withOpacity(0),
                                filled: true,
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.white),
                                focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey)),
                                border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.grey)),
                                suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.search,
                                      color: MyTheme
                                          .instance.colors.colorSecondary,
                                    ))),
                          ),
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              color: MyTheme.instance.colors.secondColorPrimary,
                              borderRadius: BorderRadius.circular(12)),
                          suggestionsCallback: (pattern) {
                            return dataBaseProvider.getSearchSuggested(
                                context, pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    suggestion.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            searchControler.text = suggestion.toString();
                            search(searchControler.text);
                          },
                          onSaved: (value) {
                            search(value!);
                          })),
                ],
              ),
              Shimmer(
                duration: Duration(seconds: 1),
                interval: Duration(milliseconds: 500),
                color: MyTheme.instance.colors.colorSecondary,
                enabled: isLoading,
                child: (searchAllResponseModel.artists.length > 0 ||
                        searchAllResponseModel.musics.length > 0 ||
                        searchAllResponseModel.albums.length > 0 ||
                        searchAllResponseModel.podcasts.length > 0 ||
                        searchAllResponseModel.videos.length > 0 ||
                        searchAllResponseModel.users.length > 0 ||
                        isLoading)
                    ? Column(children: [
                        SizedBox(
                          height: isLoading ? screenHeight * 0.7 : 16,
                        ),
                        Visibility(
                          visible: searchAllResponseModel.artists.length > 0 ||
                              searchAllResponseModel.musics.length > 0 ||
                              searchAllResponseModel.albums.length > 0 ||
                              searchAllResponseModel.podcasts.length > 0 ||
                              searchAllResponseModel.videos.length > 0 ||
                              searchAllResponseModel.users.length > 0,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color:
                                    MyTheme.instance.colors.secondColorPrimary),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: Colors.white,
                              indicator: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: MyTheme
                                          .instance.colors.secondColorPrimary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: MyTheme.instance.colors.colorPrimary),
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  icon: Image.asset(
                                    'assets/icons/artist_frame.png',
                                    width: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Tab(
                                    icon: Image.asset(
                                  'assets/icons/mini_note.png',
                                  height: 16,
                                  color: Colors.white,
                                )),
                                Tab(
                                    icon: Image.asset(
                                  'assets/icons/video.png',
                                  height: 15,
                                  color: Colors.white,
                                )),
                                Tab(
                                    icon: Image.asset(
                                  'assets/icons/album.png',
                                  width: 18,
                                  color: Colors.white,
                                )),
                                Tab(
                                    icon: Image.asset(
                                  'assets/icons/microphone_2.png',
                                  height: 18,
                                  color: Colors.white,
                                )),
                                Tab(
                                    icon: Image.asset(
                                  'assets/icons/account.png',
                                  width: 20,
                                  color: Colors.white,
                                ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.8,
                          child:
                              TabBarView(controller: _tabController, children: [
                            Container(
                              child: searchAllResponseModel.artists.length > 0
                                  ? GridView.count(
                                      crossAxisCount: 3,
                                      children: List.generate(
                                          searchAllResponseModel.artists.length,
                                          (index) {
                                        return InkWell(
                                            highlightColor: Colors.transparent
                                                .withOpacity(0),
                                            splashColor: Colors.transparent
                                                .withOpacity(0),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  SwipeablePageRoute(
                                                      builder: (context) =>
                                                          ArtistDetailScreen(
                                                              searchAllResponseModel
                                                                  .artists[
                                                                      index]
                                                                  .id)));
                                            },
                                            child: CircleArtistItem(
                                                searchAllResponseModel
                                                    .artists[index]));
                                      }),
                                    )
                                  : Container(),
                            ),
                            Container(
                              child: searchAllResponseModel.musics.length > 0
                                  ? ListView(
                                      children: searchAllResponseModel.musics
                                          .map((e) => InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                if (playerProvider.currentList
                                                            .length ==
                                                        0 ||
                                                    playerProvider
                                                            .currentList !=
                                                        searchAllResponseModel
                                                            .musics ||
                                                    playerProvider
                                                            .currentList[
                                                                playerProvider
                                                                    .currentMusicIndex]
                                                            .id !=
                                                        e.id)
                                                  playerProvider.clearAudio();
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .bottomToTop,
                                                        settings: RouteSettings(
                                                            name: 'main'),
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        child: PlayerScreen(
                                                            currentList:
                                                                searchAllResponseModel
                                                                    .musics,
                                                            currentMusicIndex:
                                                                searchAllResponseModel
                                                                    .musics
                                                                    .indexOf(
                                                                        e))));
                                              },
                                              child: VerticalSongItem(
                                                  e, false, false, 0)))
                                          .toList(),
                                    )
                                  : Container(),
                            ),
                            Container(
                              child: searchAllResponseModel.videos.length > 0
                                  ? ListView(
                                      children: searchAllResponseModel.videos
                                          .map((e) => InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                context
                                                    .read<PlayerProvider>()
                                                    .pauseAudio();
                                                Navigator.push(
                                                    context,
                                                    SwipeablePageRoute(
                                                        builder: (context) =>
                                                            MiniScreenVideoPlayer(
                                                                searchAllResponseModel
                                                                    .videos,
                                                                searchAllResponseModel
                                                                    .videos
                                                                    .indexOf(e),
                                                                'Video',
                                                                'assets/icons/video.png')));
                                              },
                                              child: VerticalVideoItem(e)))
                                          .toList(),
                                    )
                                  : Container(),
                            ),
                            Container(
                              child: searchAllResponseModel.videos.length > 0
                                  ? ListView(
                                      children: searchAllResponseModel.albums
                                          .map((e) => InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    SwipeablePageRoute(
                                                        builder: (context) =>
                                                            WithoutTabAlbumListScreen(
                                                                'Albums',
                                                                'assets/icons/note_frame_1.png',
                                                                searchAllResponseModel
                                                                    .albums)));
                                              },
                                              child: VerticalAlbumItem(e)))
                                          .toList(),
                                    )
                                  : Container(),
                            ),
                            Container(
                              child: searchAllResponseModel.podcasts.length > 0
                                  ? ListView(
                                      children: searchAllResponseModel.podcasts
                                          .map((e) => InkWell(
                                              highlightColor: Colors.transparent
                                                  .withOpacity(0),
                                              splashColor: Colors.transparent
                                                  .withOpacity(0),
                                              onTap: () {
                                                if (playerProvider.currentList
                                                            .length ==
                                                        0 ||
                                                    playerProvider
                                                            .currentList[
                                                                playerProvider
                                                                    .currentMusicIndex]
                                                            .id !=
                                                        e.id)
                                                  playerProvider.clearAudio();
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .bottomToTop,
                                                        settings: RouteSettings(
                                                            name: 'main'),
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        child: PlayerScreen(
                                                            currentList: <
                                                                MusicModel>[
                                                              ...searchAllResponseModel
                                                                  .podcasts
                                                                  .map((e1) {
                                                                return convertPodcastToMusic(
                                                                    e1);
                                                              }).toList()
                                                            ],
                                                            currentMusicIndex:
                                                                searchAllResponseModel
                                                                    .podcasts
                                                                    .indexOf(
                                                                        e))));
                                              },
                                              child: VerticalPodcastItem(
                                                  e, false)))
                                          .toList(),
                                    )
                                  : Container(),
                            ),
                            Container(
                              child: searchAllResponseModel.users.length > 0
                                  ? ListView(
                                      children:
                                          searchAllResponseModel.users.map((e) {
                                        return InkWell(
                                          highlightColor:
                                              Colors.transparent.withOpacity(0),
                                          splashColor:
                                              Colors.transparent.withOpacity(0),
                                          onTap: () {
                                            if (!context
                                                .read<AuthProvider>()
                                                .isLogin) {
                                              showGoToLoginDialog(
                                                  context, mainProvider);
                                            } else if ((UserInfos.getString(
                                                        context, 'username') ??
                                                    '') ==
                                                e.username)
                                              mainProvider.changeBottomBar(
                                                  context,
                                                  BottomBarEnum.Profile);
                                            else
                                              Navigator.push(
                                                  context,
                                                  SwipeablePageRoute(
                                                      builder: (context) =>
                                                          ProfileScreen(
                                                              e.username!,
                                                              false)));
                                          },
                                          child: VerticalUserItem(e),
                                        );
                                      }).toList(),
                                    )
                                  : Container(),
                            ),
                          ]),
                        )
                      ])
                    : Column(
                        children: [
                          if (isAdLoaded)
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              width: _ad!.size.width.toDouble(),
                              height: _ad!.size.height.toDouble(),
                              alignment: Alignment.center,
                              child: AdWidget(
                                ad: _ad!,
                              ),
                            ),
                          /*genres*/ Visibility(
                            visible: false,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(32, 32, 32, 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Genres',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: genreList.length > 0,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                                    child: Row(
                                        children: genreList.length > 0
                                            ? (genreList.length > 3
                                                    ? genreList
                                                        .getRange(0, 4)
                                                        .toList()
                                                    : genreList)
                                                .map((e) {
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
                                                                WithoutTabListWithPagingScreen(
                                                                    e.name_en!,
                                                                    'assets/icons/note.png',
                                                                    e.id!,
                                                                    0)));
                                                  },
                                                  child: genreList.indexOf(e) ==
                                                          0
                                                      ? SearchFilterItem(
                                                          e.name_en!,
                                                          screenWidth * 0.15,
                                                          screenHeight * 0.035)
                                                      : genreList.indexOf(e) ==
                                                              1
                                                          ? SearchFilterItem(
                                                              e.name_en!,
                                                              screenWidth *
                                                                  0.24,
                                                              screenHeight *
                                                                  0.035)
                                                          : genreList.indexOf(
                                                                      e) ==
                                                                  2
                                                              ? SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.24,
                                                                  screenHeight *
                                                                      0.035)
                                                              : SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.16,
                                                                  screenHeight *
                                                                      0.035),
                                                );
                                              }).toList()
                                            : []),
                                  ),
                                ),
                                Visibility(
                                  visible: genreList.length > 4,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(24, 8, 24, 4),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: genreList.length > 4
                                            ? (genreList.length > 7
                                                    ? genreList
                                                        .getRange(4, 8)
                                                        .toList()
                                                    : genreList)
                                                .map((e) {
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
                                                                WithoutTabListWithPagingScreen(
                                                                    e.name_en!,
                                                                    'assets/icons/note.png',
                                                                    e.id!,
                                                                    0)));
                                                  },
                                                  child: genreList.indexOf(e) ==
                                                          4
                                                      ? SearchFilterItem(
                                                          e.name_en!,
                                                          screenWidth * 0.11,
                                                          screenHeight * 0.035)
                                                      : genreList.indexOf(e) ==
                                                              5
                                                          ? SearchFilterItem(
                                                              e.name_en!,
                                                              screenWidth *
                                                                  0.16,
                                                              screenHeight *
                                                                  0.035)
                                                          : genreList.indexOf(
                                                                      e) ==
                                                                  6
                                                              ? SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.34,
                                                                  screenHeight *
                                                                      0.035)
                                                              : SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.18,
                                                                  screenHeight *
                                                                      0.035),
                                                );
                                              }).toList()
                                            : []),
                                  ),
                                ),
                                Visibility(
                                  visible: genreList.length > 8,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(24, 8, 24, 4),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: genreList.length > 8
                                            ? (genreList.length > 11
                                                    ? genreList
                                                        .getRange(8, 12)
                                                        .toList()
                                                    : genreList)
                                                .map((e) {
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
                                                                WithoutTabListWithPagingScreen(
                                                                    e.name_en!,
                                                                    'assets/icons/note.png',
                                                                    e.id!,
                                                                    0)));
                                                  },
                                                  child: genreList.indexOf(e) ==
                                                          4
                                                      ? SearchFilterItem(
                                                          e.name_en!,
                                                          screenWidth * 0.11,
                                                          screenHeight * 0.035)
                                                      : genreList.indexOf(e) ==
                                                              5
                                                          ? SearchFilterItem(
                                                              e.name_en!,
                                                              screenWidth *
                                                                  0.12,
                                                              screenHeight *
                                                                  0.035)
                                                          : genreList.indexOf(
                                                                      e) ==
                                                                  6
                                                              ? SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.38,
                                                                  screenHeight *
                                                                      0.035)
                                                              : SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.18,
                                                                  screenHeight *
                                                                      0.035),
                                                );
                                              }).toList()
                                            : []),
                                  ),
                                ),
                                Visibility(
                                  visible: genreList.length > 12,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(24, 8, 24, 4),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: genreList.length > 12
                                            ? (genreList.length > 11
                                                    ? genreList
                                                        .getRange(12, 16)
                                                        .toList()
                                                    : genreList)
                                                .map((e) {
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
                                                                WithoutTabListWithPagingScreen(
                                                                    e.name_en!,
                                                                    'assets/icons/note.png',
                                                                    e.id!,
                                                                    0)));
                                                  },
                                                  child: genreList.indexOf(e) ==
                                                          4
                                                      ? SearchFilterItem(
                                                          e.name_en!,
                                                          screenWidth * 0.11,
                                                          screenHeight * 0.035)
                                                      : genreList.indexOf(e) ==
                                                              5
                                                          ? SearchFilterItem(
                                                              e.name_en!,
                                                              screenWidth *
                                                                  0.12,
                                                              screenHeight *
                                                                  0.035)
                                                          : genreList.indexOf(
                                                                      e) ==
                                                                  6
                                                              ? SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.38,
                                                                  screenHeight *
                                                                      0.035)
                                                              : SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.18,
                                                                  screenHeight *
                                                                      0.035),
                                                );
                                              }).toList()
                                            : []),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          /*modes*/ Visibility(
                            visible: false,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(32, 32, 32, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Moods, Activities & Events',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: moodsList.length > 0,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(32, 16, 32, 8),
                                    child: Row(
                                        children: moodsList.length > 0
                                            ? (moodsList.length > 4
                                                    ? moodsList
                                                        .getRange(0, 4)
                                                        .toList()
                                                    : moodsList)
                                                .map((e) {
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
                                                                WithoutTabListWithPagingScreen(
                                                                    e.name_en!,
                                                                    'assets/icons/note.png',
                                                                    0,
                                                                    e.id!)));
                                                  },
                                                  child: moodsList.indexOf(e) ==
                                                          0
                                                      ? SearchFilterItem(
                                                          e.name_en!,
                                                          screenWidth * 0.15,
                                                          screenHeight * 0.035)
                                                      : moodsList.indexOf(e) ==
                                                              1
                                                          ? SearchFilterItem(
                                                              e.name_en!,
                                                              screenWidth * 0.2,
                                                              screenHeight *
                                                                  0.035)
                                                          : moodsList.indexOf(
                                                                      e) ==
                                                                  2
                                                              ? SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.24,
                                                                  screenHeight *
                                                                      0.035)
                                                              : SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.16,
                                                                  screenHeight *
                                                                      0.035),
                                                );
                                              }).toList()
                                            : []),
                                  ),
                                ),
                                Visibility(
                                  visible: moodsList.length > 4,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                                    child: Row(
                                        children: genreList.length > 4
                                            ? (genreList.length > 8
                                                    ? genreList
                                                        .getRange(4, 8)
                                                        .toList()
                                                    : genreList)
                                                .map((e) {
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
                                                                WithoutTabListWithPagingScreen(
                                                                    e.name_en!,
                                                                    'assets/icons/note.png',
                                                                    0,
                                                                    e.id!)));
                                                  },
                                                  child: genreList.indexOf(e) ==
                                                          4
                                                      ? SearchFilterItem(
                                                          e.name_en!,
                                                          screenWidth * 0.11,
                                                          screenHeight * 0.035)
                                                      : genreList.indexOf(e) ==
                                                              5
                                                          ? SearchFilterItem(
                                                              e.name_en!,
                                                              screenWidth *
                                                                  0.12,
                                                              screenHeight *
                                                                  0.035)
                                                          : genreList.indexOf(
                                                                      e) ==
                                                                  6
                                                              ? SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.34,
                                                                  screenHeight *
                                                                      0.035)
                                                              : SearchFilterItem(
                                                                  e.name_en!,
                                                                  screenWidth *
                                                                      0.18,
                                                                  screenHeight *
                                                                      0.035),
                                                );
                                              }).toList()
                                            : []),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.05,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                            child: InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeablePageRoute(
                                        builder: (context) =>
                                            WithoutTabListWithPagingScreen(
                                                'Ahanghaa Master Tracks',
                                                'assets/icons/master_star_2.png',
                                                0,
                                                0)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/master_star_2.png',
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Ahanghaa Master Tracks',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                              child: InkWell(
                                highlightColor:
                                    Colors.transparent.withOpacity(0),
                                splashColor: Colors.transparent.withOpacity(0),
                                onTap: () {
                                  mainProvider.getTopTracksList(context);
                                  Navigator.push(
                                      context,
                                      SwipeablePageRoute(
                                          builder: (context) =>
                                              TopChartsSongListScreen(
                                                  'Top Charts',
                                                  'assets/icons/note_1.png')));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/note_1.png',
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Top Charts',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 16, color: Colors.white)
                                  ],
                                ),
                              ))
                        ],
                      ),
              )
            ],
          ),
        ),
      );
    });
  }

  void search(String newValue) {
    if (_timer != null) _timer!.cancel();
    if (newValue.length > 3 && lastKeyword != newValue) {
      searchAllResponseModel = new SearchAllResponseModel();
      lastKeyword = newValue;
      _timer = Timer(Duration(milliseconds: 600), () {
        setState(() {
          isLoading = true;
        });
        _mainProvider.searchAll(context, newValue).then((value) {
          setState(() {
            if (searchControler.text.length > 3) {
              context
                  .read<DataBaseProvider>()
                  .insertSearchSuggested(context, newValue);
              searchAllResponseModel = value;
              if (searchAllResponseModel.artists.length == 0)
                _tabController!.animateTo(1);
              if (searchAllResponseModel.artists.length == 0 &&
                  searchAllResponseModel.musics.length == 0)
                _tabController!.animateTo(2);
              if (searchAllResponseModel.artists.length == 0 &&
                  searchAllResponseModel.musics.length == 0 &&
                  searchAllResponseModel.videos.length == 0)
                _tabController!.animateTo(3);

              if (searchAllResponseModel.artists.length == 0 &&
                  searchAllResponseModel.musics.length == 0 &&
                  searchAllResponseModel.videos.length == 0 &&
                  searchAllResponseModel.albums.length == 0)
                _tabController!.animateTo(4);
              if (searchAllResponseModel.artists.length == 0 &&
                  searchAllResponseModel.musics.length == 0 &&
                  searchAllResponseModel.videos.length == 0 &&
                  searchAllResponseModel.albums.length == 0 &&
                  searchAllResponseModel.podcasts.length == 0)
                _tabController!.animateTo(5);
              if (searchAllResponseModel.artists.length == 0 &&
                  searchAllResponseModel.musics.length == 0 &&
                  searchAllResponseModel.videos.length == 0 &&
                  searchAllResponseModel.albums.length == 0 &&
                  searchAllResponseModel.podcasts.length == 0 &&
                  searchAllResponseModel.users.length == 0)
                _tabController!.animateTo(0);
            }
            isLoading = false;
          });
        });
      });
    } else {
      if (lastKeyword != newValue)
        searchAllResponseModel = new SearchAllResponseModel();
      setState(() {
        isLoading = false;
      });
    }
  }
}
