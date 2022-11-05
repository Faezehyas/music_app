import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5603644115740471/8085829809";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5603644115740471/5842809840";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}