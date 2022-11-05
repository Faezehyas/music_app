import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetUserRecentlyMusicService(
    BuildContext context) async {
  GetMusicListResponseModel responseDto = new GetMusicListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "play-logs/recently", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
