import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetMusicByIdService(
    BuildContext context,int song_id) async {
  final MusicModel responseDto = MusicModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "musics/$song_id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
