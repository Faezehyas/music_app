import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetMoodsWithPagingService(
    BuildContext context,int moodId, int page, int limit) async {
  GetMusicListResponseModel responseDto = new GetMusicListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "moods/$moodId/musics?page=$page&limit=$limit", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
