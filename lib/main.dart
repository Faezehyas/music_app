import 'dart:async';
import 'dart:io';

import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/database_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/player_provider.dart';

Future<void> main() async {
  if (Platform.isAndroid) HttpOverrides.global = new AppHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainProvider()),
      ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ChangeNotifierProvider(create: (_) => DataBaseProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider())
    ],
    child: Phoenix(child: MyApp()),
  ));
}

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahanghaa',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.data,
      home: SplashScreen(),
    );
  }
}
