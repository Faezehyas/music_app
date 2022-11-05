import 'package:ahanghaa/models/album/get_latest_album_Response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetFeaturedAlbumsService(
    BuildContext context) async {
  GetLatestAlbumResponseModel responseDto = new GetLatestAlbumResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "albums/featured", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
