import 'package:ahanghaa/models/video/get_video_list_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetFeaturedVideoListService(
    BuildContext context) async {
  GetVideoListResponseModel responseDto = new GetVideoListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "videos/featured", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
