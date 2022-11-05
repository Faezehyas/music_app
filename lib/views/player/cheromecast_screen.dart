import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:cast/device.dart';
import 'package:cast/discovery_service.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter/material.dart';

class CheromecastScreen extends StatefulWidget {
  MusicModel musicModel = MusicModel();

  CheromecastScreen(this.musicModel);
 
  @override
  _CheromecastScreenState createState() => _CheromecastScreenState();
}

class _CheromecastScreenState extends State<CheromecastScreen> {
  Future<List<CastDevice>>? _future;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CastDevice>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error.toString()}',
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Chromecast founded',
              ),
            );
          }

          return Column(
            children: snapshot.data!.map((device) {
              return ListTile(
                title: Text(device.name),
                onTap: () {
                  // _connectToYourApp(context, device);
                  _connectAndPlayMedia(context, device);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }

  Future<void> _connectToYourApp(BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        ShowMessage('Connected', context);

        _sendMessageToYourApp(session);
      }
    });

    session.messageStream.listen((message) {
      print('receive message: $message');
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'com.ahanghaa.ahanghaa', // set the appId of your app here
    });
  }

  void _sendMessageToYourApp(CastSession session) {
    print('_sendMessageToYourApp');

    session.sendMessage('urn:x-cast:com.ahanghaa.ahanghaa', {
      'type': 'sample',
    });
  }

  Future<void> _connectAndPlayMedia(BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        ShowMessage('Connected', context);
      }
    });

    var index = 0;

    session.messageStream.listen((message) {
      index += 1;

      print('receive message: $message');

      if (index == 2) {
        Future.delayed(Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'com.ahanghaa.ahanghaa', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    print('_sendMessagePlayVideo');

    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId': widget.musicModel.normal_quality_url,
      'contentType': 'audio/mp3',
      'streamType': 'BUFFERED', // or LIVE

      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': widget.musicModel.title_en,
        'images': [
          {'url': widget.musicModel.cover_photo_url}
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }
}