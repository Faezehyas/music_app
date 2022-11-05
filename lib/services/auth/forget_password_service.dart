import 'package:ahanghaa/models/auth/forget_pass_request_model.dart';
import 'package:ahanghaa/models/status_response_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> ForgetPasswordService(
    BuildContext context,ForgetPassRequestModel requestModel) async {
  StatusResponseModel responseDto = new StatusResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "auth/forgot-password", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: requestModel, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
