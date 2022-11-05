import 'package:ahanghaa/models/status_response_model.dart';
import 'package:ahanghaa/models/play_list/create_playlist_request_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> AddToPlayListService(
    BuildContext context, int playListId, int musicId) async {
  StatusResponseModel responseDto = new StatusResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "user-playlists/add/$playListId/$musicId", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
