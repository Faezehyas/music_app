import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/get_play_list_response_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetUserPlayListByIdService(
    BuildContext context,int play_list_id) async {
  final PlayListModel responseDto = PlayListModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "user-playlists/$play_list_id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
