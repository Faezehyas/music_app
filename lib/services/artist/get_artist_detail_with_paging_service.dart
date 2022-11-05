import 'package:ahanghaa/models/artist/get_artist_detail_respone_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetArtistDetailListWithPagingService(
    BuildContext context,int artistId ,int page, int limit) async {
  GetArtistDetailResponeModel responseDto = new GetArtistDetailResponeModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "artists/$artistId?page=$page&limit=$limit", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
