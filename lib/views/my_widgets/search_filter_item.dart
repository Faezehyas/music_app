import 'package:ahanghaa/theme/my_theme.dart';
import 'package:flutter/material.dart';

class SearchFilterItem extends StatelessWidget {
  double _width = 0;
  double _height = 0;
  String _title = '';
  SearchFilterItem(this._title, this._width, this._height);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(colors: [
            MyTheme.instance.colors.colorSecondary2.withOpacity(0.7),
            Color(0xff283751).withOpacity(0.7),
            Color(0xff283751),
            Color(0xff283751),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
