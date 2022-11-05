import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetAlbumsMusicService(
    BuildContext context,int id) async {
  AlbumModel responseDto = new AlbumModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "albums/$id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
