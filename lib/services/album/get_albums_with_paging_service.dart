import 'package:ahanghaa/models/album/get_latest_album_Response_model.dart';
import 'package:ahanghaa/models/music/get_music_list_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetAlbumsWithPagingService(
    BuildContext context, int page, int limit) async {
  GetLatestAlbumResponseModel responseDto = new GetLatestAlbumResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "albums/latest?page=$page&limit=$limit", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
