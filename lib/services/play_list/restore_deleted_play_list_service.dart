import 'package:ahanghaa/models/status_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> RestoreDeletedPlayListService(
    BuildContext context,int playlist_id) async {
  StatusResponseModel responseDto = new StatusResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "user-playlists/restore/$playlist_id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
