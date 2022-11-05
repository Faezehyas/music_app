import 'package:ahanghaa/models/auth/change_avatar_request_model.dart';
import 'package:ahanghaa/models/auth/change_avatar_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> ChangeAvatarService(
    BuildContext context, ChangeAvatarRequestModel requestModel) async {
  ChangeAvatarResponseModel responseDto = new ChangeAvatarResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "https://www.ahanghaa.com/api/v1/auth/change-avatar", responseDto, context,
      httpMethodEnum: HttpMethodEnum.MULTIPART,
      request: requestModel,
      useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
