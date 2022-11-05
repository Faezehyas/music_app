import 'package:ahanghaa/models/enums/bottom_bar_enum.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:flutter/material.dart';

void showGoToLoginDialog(BuildContext context,MainProvider mainProvider) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            backgroundColor: MyTheme.instance.colors.colorPrimary,
            content:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You must be logged in',
                style: TextStyle(color: Colors.white),),
              ],
            ),
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
                    Navigator.pop(context);
                    mainProvider.changeBottomBar(context, BottomBarEnum.Profile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: MyTheme.instance.colors.colorSecondary),
                    ),
                  ))
            ],
          );
        });
  }

  void showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        backgroundColor: MyTheme.instance.colors.colorPrimary,
        content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(MyTheme.instance.colors.colorSecondary),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'please wait...',
                style: TextStyle(color:Colors.white),
              ),
            ]),
      ),
      context: context,
    );
  }