import 'package:ahanghaa/models/ads/get_ads_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetAdsService(
    BuildContext context) async {
  GetAdsResponseModel responseDto = new GetAdsResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "ads", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
