import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:flutter/material.dart';

import '../service_caller.dart';

Future<dynamic> SyncService(
    BuildContext context) async {
  UserModel responseDto = new UserModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "auth/sync", responseDto, context,
      httpMethodEnum: HttpMethodEnum.POST, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
