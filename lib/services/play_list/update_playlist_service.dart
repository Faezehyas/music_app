import 'package:ahanghaa/models/play_list/create_playlist_request_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> UpdatePlayListService(
    BuildContext context, CreatePlaylistRequestModel requestModel,int id) async {
  PlayListModel responseDto = new PlayListModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "user-playlists/update/$id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST,
      request: requestModel,
      useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
