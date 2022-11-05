
import 'package:ahanghaa/models/auth/change_following_state_response_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> ChangeUserFollowingService(
    BuildContext context,String userName) async {
  ChangeFollowingStateResponseModel responseDto = new ChangeFollowingStateResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "social/follow/$userName", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
