import 'package:ahanghaa/models/play_list/get_play_list_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetLatestPlayListWithPagingService(
    BuildContext context, int page, int limit) async {
  GetPlayListResponseModel responseDto = new GetPlayListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "playlists?page=$page&limit=$limit", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
