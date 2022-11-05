
import 'package:ahanghaa/models/favorite/get_favorite_list_response_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> GetFavoriteListService(
    BuildContext context) async {
  GetFavoriteListResponseModel responseDto = new GetFavoriteListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "favorites", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
