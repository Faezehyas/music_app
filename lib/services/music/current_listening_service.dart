
import 'package:ahanghaa/models/favorite/change_favorite_state_respone_model.dart';
import 'package:ahanghaa/models/status_response_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> CurrentListeningService(
    BuildContext context,int id) async {
      StatusResponseModel responseModel = StatusResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "musics/listening/$id", responseModel, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
