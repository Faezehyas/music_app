import 'dart:ui';
import 'package:flutter/material.dart';

void showBlurBottomSheet(
    BuildContext context, Widget child, Function onClosed) {
  showModalBottomSheet(
    backgroundColor: Colors.white.withOpacity(0),
    context: context,
    isScrollControlled: true,
    builder: (context) => new BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            child,
            Expanded(
                child: GestureDetector(
              onTap: () => Navigator.pop(context),
            ))
          ],
        ),
      ),
    ),
  ).then((value) => onClosed());
}
