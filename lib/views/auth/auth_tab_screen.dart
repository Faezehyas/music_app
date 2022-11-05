import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:ahanghaa/views/auth/login_screen.dart';
import 'package:ahanghaa/views/auth/profile_screen.dart';
import 'package:ahanghaa/views/auth/sign_up_screen.dart';
import 'package:ahanghaa/views/auth/user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthTabScreen extends StatefulWidget {
  @override
  _AuthTabScreenState createState() => _AuthTabScreenState();
}

class _AuthTabScreenState extends State<AuthTabScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Scaffold(
          body: authProvider.profileScreenState == ProfileScreenStateEnum.Login
              ? LoginScreen()
              : authProvider.profileScreenState == ProfileScreenStateEnum.SignUp
                  ? SignUpScreen()
                  : authProvider.profileScreenState ==
                          ProfileScreenStateEnum.Profile
                      ? ProfileScreen(
                          UserInfos.getString(context, 'username') ?? '', true)
                      : UserSettingsScreen());
    });
  }
}
