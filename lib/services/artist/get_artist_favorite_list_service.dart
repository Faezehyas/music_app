
import 'package:ahanghaa/models/artist/get_favorite_artist_response_model.dart';
import 'package:ahanghaa/models/favorite/get_favorite_list_response_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> GetArtistFavoriteListService(
    BuildContext context) async {
  GetFavoriteArtistResponseModel responseDto = new GetFavoriteArtistResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "following", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
