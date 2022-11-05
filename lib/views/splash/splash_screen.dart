import 'dart:async';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _visible = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MainProvider, AuthProvider>(
        builder: (context, mainProvider, authProvider, _) {
     mainProvider.init(context,authProvider);
      return Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            Image.asset(
              'assets/images/login_bg_1.png',
              width: screenWidth,
              height: screenHeight * 0.3,
            ),
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.2,
                ),
                Image.asset(
                  'assets/images/login_bg_2.png',
                  height: screenHeight * 0.8,
                  width: screenWidth,
                  fit: BoxFit.fill,
                )
              ],
            ),
            SizedBox(
              height: screenHeight,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.035),
                  child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset('assets/icons/splash_logo_2.png')),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight,
              child: Center(
                child: InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    child: Image.asset('assets/icons/splash_logo_1.png')),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
