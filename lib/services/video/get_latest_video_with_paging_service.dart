import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/models/video/get_video_list_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetLatestVideoListWithPagingService(
    BuildContext context, int page, int limit) async {
  GetVideoListResponseModel responseDto = new GetVideoListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "videos/latest?page=$page&limit=$limit", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
