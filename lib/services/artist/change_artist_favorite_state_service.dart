
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/favorite/change_favorite_state_respone_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> ChangeArtistFavoriteStateService(
    BuildContext context,int artistId) async {
  ArtistModel responseDto = new ArtistModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "following/$artistId", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
