import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:flutter/material.dart';

import 'offcial_tick.dart';

class CircleArtistItem extends StatelessWidget {
  ArtistModel artistModel = new ArtistModel();
  CircleArtistItem(this.artistModel);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Center(
        child: Column(
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.26,
                  height: screenWidth * 0.26,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        MyTheme.instance.colors.colorSecondary,
                        MyTheme.instance.colors.colorSecondary.withOpacity(0.3),
                        MyTheme.instance.colors.colorSecondary.withOpacity(0.0)
                      ])),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.network(
                          this.artistModel.profile_photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                (this.artistModel.name_en.length > 16
                    ? this.artistModel.name_en.substring(0, 16) + '...'
                    : this.artistModel.name_en),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            artistModel.is_verified
                ? SizedBox(
                    width: 4,
                  )
                : Container(),
            this.artistModel.is_verified
                ? SizedBox(height: 10, child: OfficialTick())
                : Container()
          ],
        ),
      ],
    ));
  }
}
