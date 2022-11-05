import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetPlayListByIdService(
    BuildContext context,int playlist_id) async {
  final PlayListModel responseDto = PlayListModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "playlists/$playlist_id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
