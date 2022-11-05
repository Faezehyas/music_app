import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetTopTrackMusicService(
    BuildContext context,String period) async {
  GetMusicListResponseModel responseDto = new GetMusicListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "top-tracks/$period", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
