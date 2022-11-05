import 'package:ahanghaa/theme/my_theme.dart';
import 'package:flutter/material.dart';

void ShowMessage(String clientMessage, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 3),
    backgroundColor: MyTheme.instance.colors.secondColorPrimary,
    content: Text(
      clientMessage,
      style: TextStyle(color: Colors.white),
    ),
  ));
}
