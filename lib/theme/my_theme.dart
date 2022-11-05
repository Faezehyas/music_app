import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

double gridSpacer = 1.25;

class _Helper {
  static double none = 0;
  static double xxs = 1;
  static double xs = 2;
  static double sm = 3;
  static double md = 4;
  static double lg = 5;
  static double xl = 6;
  static double xxl = 7;
}

// Dimensions

class SidesFlag {
  double leftFlag = 0;
  double topFlag = 0;
  double rightFlag = 0;
  double bottomFlag = 0;

  SidesFlag({
    double? left,
    double? right,
    double? top,
    double? bottom,
  })  : this.bottomFlag = bottom ?? 0,
        this.leftFlag = left ?? 0,
        this.topFlag = top ?? 0,
        this.rightFlag = right ?? 0;
}

class DimensionSize {
  double spacer;
  SidesFlag sidesFlag;
  double factor;

  DimensionSize(this.spacer, this.sidesFlag, this.factor);

  get data => EdgeInsets.fromLTRB(
        sidesFlag.leftFlag * spacer * factor,
        sidesFlag.topFlag * spacer * factor,
        sidesFlag.rightFlag * spacer * factor,
        sidesFlag.bottomFlag * spacer * factor,
      );
}

class DimensionSide {
  double spacer;
  SidesFlag sidesFlag;

  DimensionSide(this.spacer, this.sidesFlag);

  EdgeInsets get none {
    return DimensionSize(spacer, sidesFlag, _Helper.none).data;
  }

  EdgeInsets get xxs {
    return DimensionSize(spacer, sidesFlag, _Helper.xxs).data;
  }

  EdgeInsets get xs {
    return DimensionSize(spacer, sidesFlag, _Helper.xs).data;
  }

  EdgeInsets get sm {
    return DimensionSize(spacer, sidesFlag, _Helper.sm).data;
  }

  EdgeInsets get md {
    return DimensionSize(spacer, sidesFlag, _Helper.md).data;
  }

  EdgeInsets get lg {
    return DimensionSize(spacer, sidesFlag, _Helper.lg).data;
  }

  EdgeInsets get xl {
    return DimensionSize(spacer, sidesFlag, _Helper.xl).data;
  }

  EdgeInsets get xxl {
    return DimensionSize(spacer, sidesFlag, _Helper.xxl).data;
  }
}

class Dimension {
  final double? spacerValue;
  DimensionSide? _left;
  DimensionSide? _top;
  DimensionSide? _right;
  DimensionSide? _bottom;
  DimensionSide? _x;
  DimensionSide? _y;
  DimensionSide? _all;

  Dimension(this.spacerValue) {
    _left = DimensionSide(spacerValue!, SidesFlag(left: 1));
    _top = DimensionSide(spacerValue!, SidesFlag(top: 1));
    _right = DimensionSide(spacerValue!, SidesFlag(right: 1));
    _bottom = DimensionSide(spacerValue!, SidesFlag(bottom: 1));
    _x = DimensionSide(spacerValue!, SidesFlag(left: 1, right: 1));
    _y = DimensionSide(spacerValue!, SidesFlag(top: 1, bottom: 1));
    _all = DimensionSide(
        spacerValue!, SidesFlag(left: 1, right: 1, top: 1, bottom: 1));
  }

  DimensionSide get left => _left!;

  DimensionSide get top => _top!;

  DimensionSide get right => _right!;

  DimensionSide get bottom => _bottom!;

  DimensionSide get x => _x!;

  DimensionSide get y => _y!;

  DimensionSide get all => _all!;
}

// Colors

class _Colors {
  final colorPrimary = const Color(0xff182131);
  final secondColorPrimary = const Color(0xff1D2738);
  final colorSecondary3 = const Color(0xff082939);
  final colorSecondary = const Color(0xff11F2F2);
  final colorSecondary2 = const Color(0xff237272);
  final colorGreen = const Color(0xff00843E);
  final colorYellow = const Color(0XffF1D04E);
  final colorOrange = const Color(0Xffcb6d1b);
  final colorBlue = const Color(0XFF0070A4);
  final accentColor = const Color(0XFF909090);
  final colorDisable = const Color.fromRGBO(236, 236, 236, 1);
  final colorShadow = const Color.fromRGBO(0, 0, 0, 0.25);
  final myBalck = const Color(0xff070f1d);
  final myBalck2 = const Color(0xff080F1D);
}

// Shadows
class _ShadowSize extends BoxShadow {
  _ShadowSize({
    double? helper,
    Color? color,
  }) : super(
          color: color!,
          blurRadius: 0 * helper!,
          spreadRadius: 0 * helper,
        );
}

class _Shadows {
  BoxShadow get none => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.none,
      );

  BoxShadow get xxs => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.xxs,
      );

  BoxShadow get xs => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.xs,
      );

  BoxShadow get md => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.md,
      );

  BoxShadow get lg => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.lg,
      );

  BoxShadow get xl => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.xl,
      );

  BoxShadow get xxl => _ShadowSize(
        color: _Colors().colorShadow,
        helper: _Helper.xxl,
      );
}

// Base Theme

class MyTheme {
  static final instance = MyTheme();
  static final data = ThemeData(
    backgroundColor: MyTheme.instance.colors.colorPrimary,
    primaryColor: MyTheme.instance.colors.colorPrimary,
    scaffoldBackgroundColor: MyTheme.instance.colors.colorPrimary,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }
    ),
    fontFamily: 'roboto',
    brightness: Brightness.light,
    buttonTheme: ButtonThemeData(
      buttonColor: MyTheme.instance.colors.colorPrimary,
      disabledColor: MyTheme.instance.colors.colorDisable,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey.shade100.withOpacity(0.3),
      filled: true,
      contentPadding: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30),
          borderSide: BorderSide.none),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            MyTheme.instance.colors.colorSecondary,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          textStyle: MaterialStateProperty.all(const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'IRANYekan'))),
    ),
    cardTheme: CardTheme(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
    appBarTheme: AppBarTheme(centerTitle: true, color: Colors.white),
  );
  final colors = _Colors();
  final shadows = _Shadows();
  final spaces = Dimension(gridSpacer);
}

class CustomDrawer extends Drawer {}
