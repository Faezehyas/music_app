import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/providers/player_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/share_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerticalUserItem extends StatefulWidget {
  UserModel userModel = new UserModel();
  VerticalUserItem(this.userModel);
  @override
  _VerticalUserItemState createState() => _VerticalUserItemState();
}

class _VerticalUserItemState extends State<VerticalUserItem> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, PlayerProvider>(
        builder: (context, mainProvider, playerProvider, _) {
      return SizedBox(
        height: screenHeight * 0.111,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: 70,
                            height: 70,
                            color: MyTheme.instance.colors.secondColorPrimary,
                            child: widget.userModel.avatar.isNotEmpty
                                ? Image.network(widget.userModel.avatar)
                                : Center(
                                    child: Image.asset(
                                      'assets/icons/account.png',
                                      width: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userModel.username ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.userModel.name,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
