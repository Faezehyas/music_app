import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class PlayerBlurBackground extends StatelessWidget {
  String imageUrl;
  PlayerBlurBackground(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        image: imageUrl.contains('http')
            ? new DecorationImage(
                image: new NetworkImage(
                  imageUrl,
                ),
                fit: BoxFit.cover,
              )
            : new DecorationImage(
                image: new FileImage(new File(imageUrl)), fit: BoxFit.cover),
      ),
      child: new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: new Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }
}
