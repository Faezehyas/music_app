import 'dart:io';
import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/views/my_widgets/show_blur_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

void ShareMusicPicker(BuildContext context, MusicModel musicModel) {
  // FlutterShare.share(
  //     title: 'Share Via',
  //     linkUrl:
  //         'https://www.ahanghaa.com/tracks/$musicId',
  //     chooserTitle: 'Share Via');
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;
  ScreenshotController screenshotController = ScreenshotController();
  showBlurBottomSheet(
      context,
      Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: screenWidth * 0.3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          shareItem(context, (item) async {
            switch (item) {
              case 'sms':
                SocialShare.shareSms(
                    "Listen to ${musicModel.title_en} by ${musicModel.artists.singers.first.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/tracks/" +
                        musicModel.id!.toString());
                Navigator.pop(context);
                break;
              case 'copy':
                SocialShare.copyToClipboard("https://www.ahanghaa.com/tracks/" +
                    musicModel.id!.toString());
                Navigator.pop(context);
                ShowMessage('link copied', context);
                break;
              case 'more':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareOptions(
                      "https://www.ahanghaa.com/tracks/" +
                          musicModel.id!.toString(),
                      imagePath: file.path);
                  Navigator.pop(context);
                });
                break;
              case 'telegram':
                SocialShare.shareTelegram("https://www.ahanghaa.com/tracks/" +
                    musicModel.id!.toString());
                Navigator.pop(context);
                break;
              case 'whatsapp':
                SocialShare.shareWhatsapp("https://www.ahanghaa.com/tracks/" +
                    musicModel.id!.toString());
                Navigator.pop(context);
                break;
              case 'instagram':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareInstagramStory(file.path,
                      backgroundTopColor: "#237272",
                      backgroundBottomColor: "#182131",
                      attributionURL: "https://www.ahanghaa.com/tracks/" +
                          musicModel.id!.toString());
                  Navigator.pop(context);
                });
                break;
              case 'twitter':
                SocialShare.shareTwitter(
                    "Listen to ${musicModel.title_en} by ${musicModel.artists.singers.first.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/tracks/" +
                        musicModel.id!.toString(),
                    hashtags: [
                      "ahanghaa",
                      "msuic",
                      musicModel.artists.singers.first.name_en,
                      musicModel.title_en!
                    ]);
                Navigator.pop(context);
                break;
              default:
            }
          }),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Screenshot(
              controller: screenshotController,
              child: imageContent(
                  context,
                  musicModel.cover_photo_url!,
                  'assets/icons/note.png',
                  musicModel.title_en!,
                  musicModel.artists.singers.first.name_en))
        ],
      ), () {
    // setState(() {
    //   isBottomSheetLoaded = false;
    // });
  });
}

void SharePodcastPicker(BuildContext context, MusicModel musicModel) {
  // FlutterShare.share(
  //     title: 'Share Via',
  //     linkUrl: 'https://www.ahanghaa.com/podcasts/$musicId',
  //     chooserTitle: 'Share Via');
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;
  ScreenshotController screenshotController = ScreenshotController();
  showBlurBottomSheet(
      context,
      Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: screenWidth * 0.3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          shareItem(context, (item) async {
            switch (item) {
              case 'sms':
                SocialShare.shareSms(
                    "Listen to ${musicModel.title_en} by ${musicModel.artists.singers.first.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/podcasts/" +
                        musicModel.id!.toString());
                Navigator.pop(context);
                break;
              case 'copy':
                SocialShare.copyToClipboard(
                    "https://www.ahanghaa.com/podcasts/" +
                        musicModel.id!.toString());
                Navigator.pop(context);
                ShowMessage('link copied', context);
                break;
              case 'more':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareOptions(
                      "https://www.ahanghaa.com/podcasts/" +
                          musicModel.id!.toString(),
                      imagePath: file.path);
                  Navigator.pop(context);
                });
                break;
              case 'telegram':
                SocialShare.shareTelegram("https://www.ahanghaa.com/podcasts/" +
                    musicModel.id!.toString());
                Navigator.pop(context);
                break;
              case 'whatsapp':
                SocialShare.shareWhatsapp("https://www.ahanghaa.com/podcasts/" +
                    musicModel.id!.toString());
                Navigator.pop(context);
                break;
              case 'instagram':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareInstagramStory(file.path,
                      backgroundTopColor: "#237272",
                      backgroundBottomColor: "#182131",
                      attributionURL: "https://www.ahanghaa.com/podcasts/" +
                          musicModel.id!.toString());
                  Navigator.pop(context);
                });
                break;
              case 'twitter':
                SocialShare.shareTwitter(
                    "Listen by ${musicModel.title_en} from ${musicModel.artists.singers.first.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/podcasts/" +
                        musicModel.id!.toString(),
                    hashtags: [
                      "ahanghaa",
                      "podcast",
                      musicModel.artists.singers.first.name_en,
                      musicModel.title_en!
                    ]);
                Navigator.pop(context);
                break;
              default:
            }
          }),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Screenshot(
              controller: screenshotController,
              child: imageContent(
                  context,
                  musicModel.cover_photo_url!,
                  'assets/icons/note.png',
                  musicModel.title_en!,
                  musicModel.artists.singers.first.name_en))
        ],
      ), () {
    // setState(() {
    //   isBottomSheetLoaded = false;
    // });
  });
}

void SharePlayListPicker(BuildContext context, PlayListModel playListModel) {
  // FlutterShare.share(
  //     title: 'Share Via',
  //     linkUrl: 'https://www.ahanghaa.com/playlists/$playListId',
  //     chooserTitle: 'Share Via');
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;
  ScreenshotController screenshotController = ScreenshotController();
  showBlurBottomSheet(
      context,
      Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: screenWidth * 0.3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          shareItem(context, (item) async {
            switch (item) {
              case 'sms':
                SocialShare.shareSms(
                    "Listen to ${playListModel.name} playlist on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/playlists/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                break;
              case 'copy':
                SocialShare.copyToClipboard(
                    "https://www.ahanghaa.com/playlists/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                ShowMessage('link copied', context);
                break;
              case 'more':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareOptions(
                      "https://www.ahanghaa.com/playlists/" +
                          playListModel.id.toString(),
                      imagePath: file.path);
                  Navigator.pop(context);
                });
                break;
              case 'telegram':
                SocialShare.shareTelegram(
                    "https://www.ahanghaa.com/playlists/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                break;
              case 'whatsapp':
                SocialShare.shareWhatsapp(
                    "https://www.ahanghaa.com/playlists/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                break;
              case 'instagram':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareInstagramStory(file.path,
                      backgroundTopColor: "#237272",
                      backgroundBottomColor: "#182131",
                      attributionURL: "https://www.ahanghaa.com/playlists/" +
                          playListModel.id.toString());
                  Navigator.pop(context);
                });
                break;
              case 'twitter':
                SocialShare.shareTwitter(
                    "Listen to ${playListModel.name} playlist in Ahanghaa\n",
                    url: "https://www.ahanghaa.com/playlists/" +
                        playListModel.id.toString(),
                    hashtags: [
                      "ahanghaa",
                      "playlist",
                      playListModel.name,
                    ]);
                Navigator.pop(context);
                break;
              default:
            }
          }),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Screenshot(
              controller: screenshotController,
              child: imageContent(
                  context,
                  playListModel.cover_photo,
                  'assets/icons/note.png',
                  playListModel.name,
                  playListModel.music_count.toString() + " tracks"))
        ],
      ), () {
    // setState(() {
    //   isBottomSheetLoaded = false;
    // });
  });
}

void ShareUserPlayListPicker(
    BuildContext context, PlayListModel playListModel) {
  // FlutterShare.share(
  //     title: 'Share Via',
  //     linkUrl: 'https://www.ahanghaa.com/user/playlist/$playListId',
  //     chooserTitle: 'Share Via');
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;
  ScreenshotController screenshotController = ScreenshotController();
  showBlurBottomSheet(
      context,
      Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: screenWidth * 0.3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          shareItem(context, (item) async {
            switch (item) {
              case 'sms':
                SocialShare.shareSms(
                    "Listen to ${playListModel.name} by ${UserInfos.getString(context, 'username')} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/user/playlist/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                break;
              case 'copy':
                SocialShare.copyToClipboard(
                    "https://www.ahanghaa.com/user/playlist/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                ShowMessage('link copied', context);
                break;
              case 'more':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareOptions(
                      "https://www.ahanghaa.com/user/playlist/" +
                          playListModel.id.toString(),
                      imagePath: file.path);
                  Navigator.pop(context);
                });
                break;
              case 'telegram':
                SocialShare.shareTelegram(
                    "https://www.ahanghaa.com/user/playlist/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                break;
              case 'whatsapp':
                SocialShare.shareWhatsapp(
                    "https://www.ahanghaa.com/user/playlist/" +
                        playListModel.id.toString());
                Navigator.pop(context);
                break;
              case 'instagram':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareInstagramStory(file.path,
                      backgroundTopColor: "#237272",
                      backgroundBottomColor: "#182131",
                      attributionURL:
                          "https://www.ahanghaa.com/user/playlist/" +
                              playListModel.id.toString());
                  Navigator.pop(context);
                });
                break;
              case 'twitter':
                SocialShare.shareTwitter(
                    "Listen to ${playListModel.name} by ${UserInfos.getString(context, 'username')} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/user/playlist/" +
                        playListModel.id.toString(),
                    hashtags: [
                      "ahanghaa",
                      "playlist",
                      playListModel.name,
                      UserInfos.getString(context, 'username')!
                    ]);
                Navigator.pop(context);
                break;
              default:
            }
          }),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Screenshot(
              controller: screenshotController,
              child: imageContent(
                  context,
                  playListModel.cover_photo,
                  'assets/icons/note.png',
                  playListModel.name,
                  playListModel.music_count.toString() + " tracks"))
        ],
      ), () {
    // setState(() {
    //   isBottomSheetLoaded = false;
    // });
  });
}

void ShareVideoPicker(BuildContext context, VideoModel videoModel) {
  // FlutterShare.share(
  //     title: 'Share Via',
  //     linkUrl: 'https://www.ahanghaa.com/videos/$videoId',
  //     chooserTitle: 'Share Via');
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;
  ScreenshotController screenshotController = ScreenshotController();
  showBlurBottomSheet(
      context,
      Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: screenWidth * 0.3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          shareItem(context, (item) async {
            switch (item) {
              case 'sms':
                SocialShare.shareSms(
                    "Watch ${videoModel.title_en} Music Video by ${videoModel.artists.singers.first.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/videos/" +
                        videoModel.id.toString());
                Navigator.pop(context);
                break;
              case 'copy':
                SocialShare.copyToClipboard("https://www.ahanghaa.com/videos/" +
                    videoModel.id.toString());
                Navigator.pop(context);
                ShowMessage('link copied', context);
                break;
              case 'more':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareOptions(
                      "https://www.ahanghaa.com/videos/" +
                          videoModel.id.toString(),
                      imagePath: file.path);
                  Navigator.pop(context);
                });
                break;
              case 'telegram':
                SocialShare.shareTelegram("https://www.ahanghaa.com/videos/" +
                    videoModel.id.toString());
                Navigator.pop(context);
                break;
              case 'whatsapp':
                SocialShare.shareWhatsapp("https://www.ahanghaa.com/videos/" +
                    videoModel.id.toString());
                Navigator.pop(context);
                break;
              case 'instagram':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareInstagramStory(file.path,
                      backgroundTopColor: "#237272",
                      backgroundBottomColor: "#182131",
                      attributionURL: "https://www.ahanghaa.com/videos/" +
                          videoModel.id.toString());
                  Navigator.pop(context);
                });
                break;
              case 'twitter':
                SocialShare.shareTwitter(
                    "Watch ${videoModel.title_en} Music Video by ${videoModel.artists.singers.first} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/videos/" +
                        videoModel.id.toString(),
                    hashtags: [
                      "ahanghaa",
                      "musicvideo",
                      videoModel.title_en!,
                      videoModel.artists.singers.first.name_en
                    ]);
                Navigator.pop(context);
                break;
              default:
            }
          }),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Screenshot(
              controller: screenshotController,
              child: imageContent(
                  context,
                  videoModel.cover_photo_url!,
                  'assets/icons/video.png',
                  videoModel.title_en!,
                  videoModel.artists.singers.first.name_en))
        ],
      ), () {
    // setState(() {
    //   isBottomSheetLoaded = false;
    // });
  });
}

void ShareAlbumPicker(BuildContext context, AlbumModel albumModel) {
  // FlutterShare.share(
  //     title: 'Share Via',
  //     linkUrl: 'https://www.ahanghaa.com/albums/$AlbumId',
  //     chooserTitle: 'Share Via');
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;
  ScreenshotController screenshotController = ScreenshotController();
  showBlurBottomSheet(
      context,
      Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: screenWidth * 0.3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent.withOpacity(0),
                splashColor: Colors.transparent.withOpacity(0),
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          shareItem(context, (item) async {
            switch (item) {
              case 'sms':
                SocialShare.shareSms(
                    "Listen to ${albumModel.title_en} by ${albumModel.artist.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/albums/" +
                        albumModel.id.toString());
                Navigator.pop(context);
                break;
              case 'copy':
                SocialShare.copyToClipboard("https://www.ahanghaa.com/albums/" +
                    albumModel.id.toString());
                Navigator.pop(context);
                ShowMessage('link copied', context);
                break;
              case 'more':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareOptions(
                      "https://www.ahanghaa.com/albums/" +
                          albumModel.id.toString(),
                      imagePath: file.path);
                  Navigator.pop(context);
                });
                break;
              case 'telegram':
                SocialShare.shareTelegram("https://www.ahanghaa.com/albums/" +
                    albumModel.id.toString());
                Navigator.pop(context);
                break;
              case 'whatsapp':
                SocialShare.shareWhatsapp("https://www.ahanghaa.com/albums/" +
                    albumModel.id.toString());
                Navigator.pop(context);
                break;
              case 'instagram':
                await screenshotController.capture().then((image) async {
                  final directory = await getApplicationDocumentsDirectory();
                  final file =
                      await File('${directory.path}/temp.png').create();
                  await file.writeAsBytes(image!);
                  SocialShare.shareInstagramStory(file.path,
                      backgroundTopColor: "#237272",
                      backgroundBottomColor: "#182131",
                      attributionURL: "https://www.ahanghaa.com/albums/" +
                          albumModel.id.toString());
                  Navigator.pop(context);
                });
                break;
              case 'twitter':
                SocialShare.shareTwitter(
                    "Listen to ${albumModel.title_en} by ${albumModel.artist.name_en} on Ahanghaa\n",
                    url: "https://www.ahanghaa.com/albums/" + albumModel.id.toString(),
                    hashtags: [
                      "ahanghaa",
                      "album",
                      albumModel.title_en,
                      albumModel.artist.name_en
                    ]);
                Navigator.pop(context);
                break;
              default:
            }
          }),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Screenshot(
              controller: screenshotController,
              child: imageContent(
                  context,
                  albumModel.cover_photo_url,
                  'assets/icons/album.png',
                  albumModel.title_en,
                  albumModel.artist.name_en))
        ],
      ), () {
    // setState(() {
    //   isBottomSheetLoaded = false;
    // });
  });
}

void ShareProfilePicker(String userName) {
  FlutterShare.share(
      title: 'Share Via',
      linkUrl: 'https://www.ahanghaa.com/users/$userName',
      chooserTitle: 'Share Via');
}

void ShareArtistProfilePicker(int artistId) {
  FlutterShare.share(
      title: 'Share Via',
      linkUrl: 'https://www.ahanghaa.com/artists/$artistId',
      chooserTitle: 'Share Via');
}

Widget shareItem(BuildContext context, Function(String item) onItem) => Column(
      verticalDirection: VerticalDirection.up,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('sms'),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyTheme.instance.colors.colorGreen),
                          child: Center(
                              child: Image.asset(
                            'assets/icons/message.png',
                            width: 24,
                          )),
                        ),
                        Text(
                          'Message',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('copy'),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Center(
                            child: Icon(
                              Icons.copy,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Copy Link',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('more'),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Center(
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'More',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('telegram'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/telegram.png',
                          width: 48,
                        ),
                        Text(
                          'Telegram',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('whatsapp'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/whatsapp.png',
                          width: 48,
                        ),
                        Text(
                          'WhatsApp',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('instagram'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/instagram.png',
                          width: 48,
                        ),
                        Text(
                          'Instagram',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onItem('twitter'),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/twitter.png',
                          width: 48,
                        ),
                        Text(
                          'Twitter',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

Widget imageContent(BuildContext context, String img, String icon, String title,
        String name) =>
    Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: CachedNetworkImage(
            imageUrl: img,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.9,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              color: Colors.white,
              width: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 18, color: Colors.grey.shade300),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Play on ahanghaa.com',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ],
    );
