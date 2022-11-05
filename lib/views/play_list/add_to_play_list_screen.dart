import 'dart:io';

import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/views/my_widgets/vertical_play_list_item.dart';
import 'package:ahanghaa/views/my_widgets/vertical_play_list_item_without_option.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AddToPlayListScreen extends StatefulWidget {
  int musicId;
  AddToPlayListScreen(this.musicId);

  @override
  _AddToPlayListScreenState createState() => _AddToPlayListScreenState();
}

class _AddToPlayListScreenState extends State<AddToPlayListScreen> {
  TextEditingController nameController = new TextEditingController();
  List<PlayListModel> loadedPlayList = [];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MainProvider>(builder: (context, mainProvider, _) {
      // mainProvider.getUserPlayList(context).then((value) {
      //   setState(() {
      //     loadedPlayList = value;
      //   });
      // });
      return Scaffold(
        floatingActionButton: Visibility(
          visible: (UserInfos.getToken(context) != null &&
              UserInfos.getToken(context)!.isNotEmpty),
          child: FloatingActionButton(
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
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      backgroundColor: MyTheme.instance.colors.colorPrimary,
                      content:
                          StatefulBuilder(builder: (context, dialogSetState) {
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
                                                      BorderRadius.circular(12),
                                                  child: image != null
                                                      ? Image.file(
                                                          File(image!.path),
                                                          width:
                                                              screenWidth * 0.2,
                                                          height:
                                                              screenWidth * 0.2,
                                                          fit: BoxFit.cover)
                                                      : Image.network(
                                                          'https://www.ahanghaa.com/images/default-playlist.jpg',
                                                          fit: BoxFit.cover,
                                                        )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      verticalDirection:
                                                          VerticalDirection.up,
                                                      children: [
                                                        InkWell(
                                                          highlightColor: Colors
                                                              .transparent
                                                              .withOpacity(0),
                                                          splashColor: Colors
                                                              .transparent
                                                              .withOpacity(0),
                                                          onTap: () async {
                                                            final ImagePicker
                                                                _picker =
                                                                ImagePicker();
                                                            var data = await _picker
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                            if (data != null) {
                                                              File file = File(
                                                                  data.path);
                                                              if ((file.lengthSync() /
                                                                      1024) <=
                                                                  5120)
                                                                dialogSetState(
                                                                    () {
                                                                  image = file;
                                                                });
                                                              else
                                                                ShowMessage(
                                                                    'file size cannot biggest than 5mb',
                                                                    context);
                                                            }
                                                          },
                                                          child: Container(
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
                                                              color:
                                                                  Colors.white,
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
                                          if (value == null || value.isEmpty) {
                                            return 'enter playlist name';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                        decoration:
                                            InputDecoration(hintText: 'Name'),
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
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color:
                                        MyTheme.instance.colors.colorSecondary),
                              ),
                            )),
                        InkWell(
                            highlightColor: Colors.transparent.withOpacity(0),
                            splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                mainProvider
                                    .createNewPlayListWithAddMusic(
                                        context,
                                        widget.musicId,
                                        nameController.text,
                                        image != null ? image : null)
                                    .then((value) {
                                  setState(() {
                                    loadedPlayList = value;
                                  });
                                });
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ShowMessage('Added to PlayList', context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Create PlayList',
                                style: TextStyle(
                                    color:
                                        MyTheme.instance.colors.colorSecondary),
                              ),
                            ))
                      ],
                    );
                  });
            },
            child: Icon(Icons.add),
          ),
        ),
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
                        'Add to PlayList',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        'assets/icons/note.png',
                        width: 20,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: (UserInfos.getToken(context) != null &&
                      UserInfos.getToken(context)!.isNotEmpty)
                  ? ListView(
                      children: mainProvider.userPlayListList
                          .map((e) => InkWell(
                              highlightColor: Colors.transparent.withOpacity(0),
                              splashColor: Colors.transparent.withOpacity(0),
                              onTap: () {
                                mainProvider
                                    .addToPlayList(
                                        context, widget.musicId, e.id)
                                    .then((value) {
                                  loadedPlayList = value;
                                });
                                Navigator.pop(context);
                                ShowMessage('Added to PlayList', context);
                              },
                              child:
                                  VerticalPlayListItemWithoutOption(e, false)))
                          .toList(),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You must be logged in',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          SizedBox(
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.06,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    mainProvider.changeBottomBar(
                                        context, BottomBarEnum.Profile);
                                  },
                                  child: Text('Sign In'))),
                        ],
                      ),
                    ),
            )
          ],
        ),
      );
    });
  }
}
