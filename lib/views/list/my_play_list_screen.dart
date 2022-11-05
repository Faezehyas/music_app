import 'dart:io';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/views/my_widgets/vertical_play_list_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_play_list_item_without_option.dart';
import 'package:ahanghaa/views/play_list/play_list_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class MyPlayListScreen extends StatefulWidget {
  String title = '';
  String iconUrl = '';

  MyPlayListScreen(this.title, this.iconUrl);

  @override
  _MyPlayListScreenState createState() => _MyPlayListScreenState();
}

class _MyPlayListScreenState extends State<MyPlayListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MainProvider _mainProvider = new MainProvider();
  PlayerProvider _playerProvider = new PlayerProvider();
  List<PlayListModel> loadedList = [];
  TextEditingController nameController = new TextEditingController();
  bool isInit = false;
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
    _tabController = TabController(length: 3, vsync: this);
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
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      _mainProvider = mainProvider;
      _playerProvider = playerProvider;
      if (!isInit) {
        isInit = true;
        mainProvider.getDeletedPlayList(context);
      }
      return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            SizedBox(
              height: screenHeight * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      highlightColor: Colors.transparent.withOpacity(0),
                      splashColor: Colors.transparent.withOpacity(0),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        widget.iconUrl,
                        width: 18,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isAdLoaded)
              Container(
                width: _ad!.size.width.toDouble(),
                height: _ad!.size.height.toDouble(),
                alignment: Alignment.center,
                child: AdWidget(
                  ad: _ad!,
                ),
              )
            else
              SizedBox(
                height: screenHeight * 0.02,
              ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: MyTheme.instance.colors.colorSecondary,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'My Playlist',
                ),
                Tab(
                  text: 'Saved Playlist',
                ),
                Tab(
                  text: 'Deleted Playlist',
                ),
              ],
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
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: MyTheme.instance.colors.colorSecondary,
                  mini: true,
                  onPressed: () {
                    final _formKey = GlobalKey<FormState>();
                    showDialog(
                        context: context,
                        builder: (context) {
                          File? image;
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                'New Playlist',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            backgroundColor:
                                MyTheme.instance.colors.colorPrimary,
                            content: StatefulBuilder(
                                builder: (context, dialogSetState) {
                              return Form(
                                key: _formKey,
                                child: Container(
                                  height: screenHeight * 0.2,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.2,
                                                height: screenWidth * 0.2,
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                        child: image != null
                                                            ? Image.file(
                                                                File(image!
                                                                    .path),
                                                                width:
                                                                    screenWidth *
                                                                        0.2,
                                                                height:
                                                                    screenWidth *
                                                                        0.2,
                                                                fit: BoxFit
                                                                    .cover)
                                                            : Image.network(
                                                                'https://www.ahanghaa.com/images/default-playlist.jpg',
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Column(
                                                            verticalDirection:
                                                                VerticalDirection
                                                                    .up,
                                                            children: [
                                                              InkWell(
                                                                highlightColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                splashColor: Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0),
                                                                onTap:
                                                                    () async {
                                                                  final ImagePicker
                                                                      _picker =
                                                                      ImagePicker();
                                                                  var data = await _picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                                  if (data !=
                                                                      null) {
                                                                    File file =
                                                                        File(data
                                                                            .path);
                                                                    if ((file.lengthSync() /
                                                                            1024) <=
                                                                        5120)
                                                                      dialogSetState(
                                                                          () {
                                                                        image =
                                                                            file;
                                                                      });
                                                                    else
                                                                      ShowMessage(
                                                                          'file size cannot biggest than 5mb',
                                                                          context);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 24,
                                                                  height: 24,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: MyTheme
                                                                        .instance
                                                                        .colors
                                                                        .colorSecondary,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.75,
                                            child: TextFormField(
                                              controller: nameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'enter playlist name';
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                  hintText: 'Name'),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                            actions: [
                              InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: MyTheme
                                              .instance.colors.colorSecondary),
                                    ),
                                  )),
                              InkWell(
                                  highlightColor:
                                      Colors.transparent.withOpacity(0),
                                  splashColor:
                                      Colors.transparent.withOpacity(0),
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      mainProvider.createNewPlayList(
                                          context,
                                          nameController.text,
                                          image != null ? image : null);
                                      Navigator.pop(context);
                                      nameController.text = '';
                                      image = null;
                                      ShowMessage(
                                          'Added new Playlist', context);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Create Playlist',
                                      style: TextStyle(
                                          color: MyTheme
                                              .instance.colors.colorSecondary),
                                    ),
                                  ))
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.add),
                ),
                backgroundColor: MyTheme.instance.colors.secondColorPrimary,
                body: ListView(
                  children: mainProvider.userPlayListList
                      .map((e) => InkWell(
                          highlightColor: Colors.transparent.withOpacity(0),
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            Navigator.push(
                                context,
                                SwipeablePageRoute(
                                    settings: RouteSettings(name: 'main'),
                                    builder: (context) =>
                                        PlayListDetailScreen(e, true)));
                          },
                          child: VerticalPlayListItem(e, true)))
                      .toList(),
                ),
              ),
              Container(
                  color: MyTheme.instance.colors.secondColorPrimary,
                  child: ListView(
                    children: mainProvider.favoritePlayList
                        .map((e) => InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SwipeablePageRoute(
                                      settings: RouteSettings(name: 'main'),
                                      builder: (context) =>
                                          PlayListDetailScreen(e, false)));
                            },
                            child: VerticalPlayListItem(e, false)))
                        .toList(),
                  )),
              Container(
                  color: MyTheme.instance.colors.secondColorPrimary,
                  child: ListView(
                    children: mainProvider.deletedPlayList
                        .map((e) => InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {},
                            child: VerticalPlayListItemWithoutOption(e, true)))
                        .toList(),
                  )),
            ]))
          ],
        ),
      );
    });
  }
}
