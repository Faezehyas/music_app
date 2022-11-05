import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetVideoByIdService(
    BuildContext context,int video_id) async {
  final VideoModel responseDto = VideoModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "videos/$video_id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
