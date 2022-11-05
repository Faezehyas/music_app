import 'package:ahanghaa/providers/main_provider.dart';
import 'package:flutter/widgets.dart';

class UserInfos {
  static clear() => MainProvider.sharedPreferences.clear();

  static setToken(BuildContext context, String token) async {
    await MainProvider.sharedPreferences.setString('token', token);
  }

  static String? getToken(BuildContext context) {
    return MainProvider.sharedPreferences.getString('token');
  }

  static setRefreshToken(BuildContext context, String token) async {
    await MainProvider.sharedPreferences.setString('refreshToken', token);
  }

  static String? getRefreshToken(BuildContext context) {
    return MainProvider.sharedPreferences.getString('refreshToken');
  }

  static setMobile(BuildContext context, String mobile) async {
    await MainProvider.sharedPreferences.setString('mobile', mobile);
  }

  static String? getMobile(BuildContext context) {
    return MainProvider.sharedPreferences.getString('mobile');
  }

  static setId(BuildContext context, String Id) async {
    await MainProvider.sharedPreferences.setString('Id', Id);
  }

  static String? getId(BuildContext context) {
    return MainProvider.sharedPreferences.getString('Id');
  }

  //for unknown value
  static setString(BuildContext context, String name, String value) async {
    await MainProvider.sharedPreferences.setString(name, value);
  }

  static setListString(BuildContext context, String name, List<String> value) async {
    await MainProvider.sharedPreferences.setStringList(name, value);
  }

  static setInt(BuildContext context, String name, int value) async {
    await MainProvider.sharedPreferences.setInt(name, value);
  }

  static setBool(BuildContext context, String name, bool value) async {
    await MainProvider.sharedPreferences.setBool(name, value);
  }

  static String? getString(BuildContext context, String name) {
    return MainProvider.sharedPreferences.getString(name);
  }

  static List<String>? getListString(BuildContext context, String name) {
    return MainProvider.sharedPreferences.getStringList(name);
  }

  static int? getInt(BuildContext context, String name) {
    return MainProvider.sharedPreferences.getInt(name);
  }

  static bool? getbool(BuildContext context, String name) {
    return MainProvider.sharedPreferences.getBool(name);
  }

  //for unknown value
  
  static remove(String name) => MainProvider.sharedPreferences.remove(name);
}
