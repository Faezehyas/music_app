import 'package:ahanghaa/models/play_list/create_playlist_request_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> CreateNewPlayListService(
    BuildContext context, CreatePlaylistRequestModel requestModel) async {
  PlayListModel responseDto = new PlayListModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "https://www.ahanghaa.com/api/v1/user-playlists", responseDto, context,
      httpMethodEnum: HttpMethodEnum.MULTIPART,
      request: requestModel,
      useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
