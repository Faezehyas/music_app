import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetAllSlidersService(
    BuildContext context) async {
  final GetSlidersResponseModel responseDto = GetSlidersResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "slides", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
