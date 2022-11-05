import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/get_play_list_response_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetFeaturedPlayListService(
    BuildContext context) async {
  GetPlayListResponseModel responseDto = new GetPlayListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "playlists/featured", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
