import 'package:ahanghaa/models/email/send_email_request_model.dart';
import 'package:ahanghaa/models/favorite/change_favorite_state_respone_model.dart';
import 'package:ahanghaa/models/status_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> SendEmailService(
    BuildContext context, SendEmailRequestModel requestModel) async {
  StatusResponseModel responseDto = new StatusResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "message", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: requestModel, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
