import 'package:ahanghaa/models/auth/sign_up_request_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> SignUpService(
    BuildContext context,SignUpRequestModel requestModel) async {
  UserModel responseDto = new UserModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "https://www.ahanghaa.com/api/v1/auth/signup", responseDto, context,
      httpMethodEnum: HttpMethodEnum.MULTIPART, request: requestModel, useDefaultHost: false);
  await serviceCaller.call();
  return serviceCaller.response;
}
