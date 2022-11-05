import 'dart:io';
import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  File? image;
  BannerAd? _ad;
  bool isAdLoaded = false;
  String _version = '';

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
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _version = value.version;
      });
    });
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
    return Dismissible(
      key: Key(UniqueKey().toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        context
            .read<AuthProvider>()
            .changeProfileScreen(ProfileScreenStateEnum.Profile);
      },
      child: Consumer2<AuthProvider, MainProvider>(
          builder: (context, authProvider, mainProvider, _) {
        return Scaffold(
            body: ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      authProvider
                          .changeProfileScreen(ProfileScreenStateEnum.Profile);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.notifications_none_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      MyTheme.instance.colors.colorSecondary),
                              child: Center(
                                child: Text(
                                  '14',
                                  style: TextStyle(
                                      color:
                                          MyTheme.instance.colors.colorPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  /*user email*/ Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          SizedBox(
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.25,
                            child: Stack(
                              children: [
                                image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: screenWidth * 0.25,
                                          height: screenWidth * 0.25,
                                          child: Image.file(
                                            File(
                                              image!.path,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : authProvider.avatar.isEmpty
                                        ? Container(
                                            width: screenWidth * 0.25,
                                            height: screenWidth * 0.25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/icons/avatar2.png'),
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: SizedBox(
                                              width: screenWidth * 0.25,
                                              height: screenWidth * 0.25,
                                              child: Image.network(
                                                authProvider.avatar,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        verticalDirection: VerticalDirection.up,
                                        children: [
                                          InkWell(
                                            highlightColor: Colors.transparent
                                                .withOpacity(0),
                                            splashColor: Colors.transparent
                                                .withOpacity(0),
                                            onTap: () async {
                                              final ImagePicker _picker =
                                                  ImagePicker();
                                              var data =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              try {
                                                if (data != null) {
                                                  File file = File(data.path);
                                                  if ((file.lengthSync() /
                                                          1024) <=
                                                      5120) {
                                                    setState(() {
                                                      image = file;
                                                    });
                                                    authProvider.changeAvatar(
                                                        context, image!);
                                                  } else
                                                    ShowMessage(
                                                        'file size cannot biggest than 5mb',
                                                        context);
                                                }
                                              } catch (e) {
                                                ShowMessage(
                                                    'in view : $e', context);
                                              }
                                            },
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: MyTheme.instance.colors
                                                    .colorSecondary,
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
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
                          ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.55,
                                child: Row(
                                  children: [
                                    Text(
                                      UserInfos.getString(
                                              context, 'username') ??
                                          '',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: screenWidth * 0.02,
                              // ),
                              // SizedBox(
                              //   width: screenWidth * 0.6,
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         'View Profile',
                              //         style: TextStyle(
                              //           color: Colors.grey,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                      // Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.white,
                      //   size: 16,
                      // )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  // /*upgrade btn*/ SizedBox(
                  //     width: double.infinity,
                  //     height: screenHeight * 0.05,
                  //     child: ElevatedButton(
                  //         style: ButtonStyle(
                  //             backgroundColor: MaterialStateProperty.all(
                  //               Color(0xffF1D04E),
                  //             ),
                  //             shape: MaterialStateProperty.all(
                  //               RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //             )),
                  //         onPressed: () async {},
                  //         child: Text(
                  //           'Upgrade to Premium',
                  //           style: TextStyle(
                  //               color: MyTheme.instance.colors.colorPrimary),
                  //         ))),
                  // SizedBox(
                  //   height: screenHeight * 0.05,
                  // ),
                  /*options*/ Row(
                    children: [
                      Text(
                        'Options',
                        style: TextStyle(
                            color: MyTheme.instance.colors.colorSecondary,
                            fontSize: 18),
                      )
                    ],
                  ),
                  Visibility(
                    visible: false,
                    child: SizedBox(
                      height: screenHeight * 0.03,
                    ),
                  ),
                  /*notfication toggle*/ Visibility(
                    visible: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent.withOpacity(0),
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            // setState(() => {
                            //       UserInfos.setBool(
                            //           context,
                            //           'notif',
                            //           !(UserInfos.getbool(context, 'notif') ??
                            //               false))
                            //     });
                            // context.read<MainProvider>().isInit = false;
                            // Phoenix.rebirth(context);
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 32,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              Visibility(
                                visible:
                                    !(UserInfos.getbool(context, 'notif') ??
                                        false),
                                child: SizedBox(
                                  height: 16,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                              color: MyTheme
                                                  .instance.colors.colorPrimary,
                                              shape: BoxShape.circle)),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: UserInfos.getbool(context, 'notif') ??
                                    false,
                                child: SizedBox(
                                  height: 16,
                                  width: 32,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 2),
                                          child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      clearSearch(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Clear Search History',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  // InkWell(
                  //   highlightColor: Colors.transparent.withOpacity(0),
                  //   splashColor: Colors.transparent.withOpacity(0),
                  //   onTap: () {
                  //     deleteRecentlyPlayed();
                  //   },
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           'Clear Recently Played',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       ]),
                  // ),
                  // SizedBox(
                  //   height: screenHeight * 0.03,
                  // ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      deleteDownloaded(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delete Download Music',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      resetAll(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reset All',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.015,
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
                    height: screenHeight * 0.015,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    children: [
                      Text(
                        'Folow us',
                        style: TextStyle(
                            color: MyTheme.instance.colors.colorSecondary,
                            fontSize: 18),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      await launch('https://instagram.com/ahanghaa_com');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Instagram',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      await launch('https://www.facebook.com/Ahanghaaofficial');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Facebook',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent.withOpacity(0),
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            showEmailDialog(context);
                          },
                          child: Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      await launch('https://www.ahanghaa.com/support');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Help & Support',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () async {
                      await launch('https://www.ahanghaa.com/tos');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent.withOpacity(0),
                        splashColor: Colors.transparent.withOpacity(0),
                        onTap: () => authProvider.logout(),
                        child: Text(
                          'LOG OUT',
                          style: TextStyle(
                              color: MyTheme.instance.colors.colorSecondary,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_version, style: TextStyle(color: Colors.grey))
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.06,
                  ),
                ],
              ),
            ),
          ],
        ));
      }),
    );
  }

  deleteRecentlyPlayed() {
    // context.read<DataBaseProvider>().deleteAllRecenltyPlayed();
    // context.read<MainProvider>().recentlyPlayedList = [];
    // ShowMessage('Cleared', context);
  }

  deleteDownloaded(BuildContext context) {
    context.read<DataBaseProvider>().deleteAllDownloaded();
    context.read<MainProvider>().downloadedList = [];
    context.read<MainProvider>().filledDownloadedList = [];
    ShowMessage('Deleted', context);
  }

  resetAll(BuildContext context) {
    // context.read<DataBaseProvider>().deleteAllRecenltyPlayed();
    // context.read<MainProvider>().recentlyPlayedList = [];
    context.read<DataBaseProvider>().deleteAllDownloaded();
    context.read<MainProvider>().downloadedList = [];
    context.read<MainProvider>().filledDownloadedList = [];
    MainProvider.sharedPreferences.remove('search');
    ShowMessage('Reseted All', context);
  }

  void clearSearch(BuildContext context) {
    MainProvider.sharedPreferences.remove('search');
    ShowMessage('Cleared', context);
  }

  void showEmailDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    TextEditingController subjectController = new TextEditingController();
    TextEditingController messageTextControler = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Send Email',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            backgroundColor: MyTheme.instance.colors.colorPrimary,
            content: StatefulBuilder(builder: (context, dialogSetState) {
              return Form(
                key: _formKey,
                child: Container(
                  height: screenHeight * 0.29,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.75,
                            child: TextFormField(
                              controller: subjectController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter subject';
                                }
                                return null;
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              decoration: InputDecoration(hintText: 'subject'),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            maxLines: 6,
                            keyboardType: TextInputType.multiline,
                            controller: messageTextControler,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter messsage';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            decoration: new InputDecoration(
                              hintText: 'message',
                            ),
                          ),
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
                          color: MyTheme.instance.colors.colorSecondary),
                    ),
                  )),
              InkWell(
                  highlightColor: Colors.transparent.withOpacity(0),
                  splashColor: Colors.transparent.withOpacity(0),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<MainProvider>().sendEmail(context,
                          subjectController.text, messageTextControler.text);
                      Navigator.pop(context);
                      ShowMessage('email sent', context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                    ),
                  ))
            ],
          );
        });
  }
}
