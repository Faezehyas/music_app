import 'dart:io';

import 'package:ahanghaa/db/my_database.dart';
import 'package:ahanghaa/models/auth/change_avatar_request_model.dart';
import 'package:ahanghaa/models/auth/change_avatar_response_model.dart';
import 'package:ahanghaa/models/auth/change_following_state_response_model.dart';
import 'package:ahanghaa/models/auth/forget_pass_request_model.dart';
import 'package:ahanghaa/models/auth/profile_model.dart';
import 'package:ahanghaa/models/auth/sign_in_request_model.dart';
import 'package:ahanghaa/models/auth/sign_up_request_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/models/status_response_model.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/services/auth/change_avatar_service.dart';
import 'package:ahanghaa/services/auth/change_user_following_service.dart';
import 'package:ahanghaa/services/auth/forget_password_service.dart';
import 'package:ahanghaa/services/auth/get_user_profile_service.dart';
import 'package:ahanghaa/services/auth/reset_password_service.dart';
import 'package:ahanghaa/services/auth/sign_in_service.dart';
import 'package:ahanghaa/services/auth/sign_up_service.dart';
import 'package:ahanghaa/utils/show_popup.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  bool isLogin = false;
  ProfileScreenStateEnum profileScreenState = ProfileScreenStateEnum.Login;
  String avatar = '';

  setAvatar(String url) {
    avatar = url;
    notifyListeners();
  }

  changeProfileScreen(ProfileScreenStateEnum _profileScreenStateEnum) {
    profileScreenState = _profileScreenStateEnum;
    notifyListeners();
  }

  changeLoginState(bool state) {
    isLogin = state;
    notifyListeners();
  }

  logout() async {
    UserInfos.clear();
    avatar = '';
    profileScreenState = ProfileScreenStateEnum.Login;
    isLogin = false;
    changeLoginState(false);
    notifyListeners();
  }

  signUp(BuildContext context, String name, String? userName, String email,
      String password) async {
    SignUpRequestModel signUpRequestModel = new SignUpRequestModel();
    signUpRequestModel.name = name;
    signUpRequestModel.username = userName ?? '';
    signUpRequestModel.email = email;
    signUpRequestModel.password = password;
    String? token = await FirebaseMessaging.instance.getToken();
    signUpRequestModel.fcm_token = token!;
    UserModel res = await SignUpService(context, signUpRequestModel);
    if (res.id > 0) {
      UserInfos.setToken(context, 'Bearer ' + res.api_token);
      UserInfos.setId(context, res.id.toString());
      UserInfos.setString(context, 'name', name);
      UserInfos.setString(context, 'email', email);
      if (userName != null) UserInfos.setString(context, 'username', userName);
      changeLoginState(true);
      changeProfileScreen(ProfileScreenStateEnum.Profile);
    }
  }

  signIn(BuildContext context, String email, String password) async {
    SignInRequestModel signInRequestModel = new SignInRequestModel();
    signInRequestModel.email = email;
    signInRequestModel.password = password;
    String? token = await FirebaseMessaging.instance.getToken();
    signInRequestModel.fcm_token = token!;
    UserModel res = await SignInService(context, signInRequestModel);
    if (res.id > 0) {
      UserInfos.setToken(context, 'Bearer ' + res.api_token);
      UserInfos.setId(context, res.id.toString());
      UserInfos.setString(context, 'username', res.username!);
      UserInfos.setString(context, 'name', res.name);
      UserInfos.setString(context, 'email', res.email);
      UserInfos.setBool(context, 'notif', true);
      changeLoginState(true);
      changeProfileScreen(ProfileScreenStateEnum.Profile);
    }
  }

  Future<ProfileModel> getUserProfile(
      BuildContext context, String userName) async {
    ProfileModel res = await GetUserProfileService(context, userName);
    if ((UserInfos.getString(context, 'username') ?? '') == userName) {
      res.playlists = await new MainProvider().getUserPlayList(context);
      return res;
    } else
      return res;
  }

  Future<bool> changeUserFollowing(
      BuildContext context, String userName) async {
    ChangeFollowingStateResponseModel res =
        await ChangeUserFollowingService(context, userName);
    return res.is_followed;
  }

  Future<bool> forgetPassword(
      BuildContext context, String email) async {
        ForgetPassRequestModel requestModel = new ForgetPassRequestModel();
        requestModel.email = email;
    StatusResponseModel res =
        await ForgetPasswordService(context, requestModel);
    return res.success;
  }

  Future<bool> resetPassword(
      BuildContext context, String email,String otp, String newPass) async {
        ForgetPassRequestModel requestModel = new ForgetPassRequestModel();
        requestModel.email = email;
        requestModel.otp = otp;
        requestModel.new_password = newPass;
    StatusResponseModel res =
        await ResetPasswordService(context, requestModel);
    return res.success;
  }

  Future<void> changeAvatar(BuildContext context, File avatar) async {
    ChangeAvatarRequestModel requestModel = new ChangeAvatarRequestModel();
    requestModel.avatar = avatar;
    showLoading(context);
    ChangeAvatarResponseModel res =
        await ChangeAvatarService(context, requestModel);
        Navigator.pop(context);
    if (res.avatar.isNotEmpty) setAvatar(res.avatar);
  }
}
