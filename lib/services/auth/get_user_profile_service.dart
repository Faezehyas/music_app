
import 'package:ahanghaa/models/auth/profile_model.dart';
import 'package:ahanghaa/models/favorite/get_favorite_list_response_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> GetUserProfileService(
    BuildContext context,String userName) async {
  ProfileModel responseDto = new ProfileModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "social/profile/$userName", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
