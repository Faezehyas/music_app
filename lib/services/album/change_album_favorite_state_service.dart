
import 'package:ahanghaa/models/favorite/change_favorite_state_respone_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> ChangeAlbumFavoriteStateService(
    BuildContext context,int id) async {
  ChangeFavoriteStateResponseModel responseDto = new ChangeFavoriteStateResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "favorites/album/$id", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
