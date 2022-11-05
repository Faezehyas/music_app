import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/search/search_all_response_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> SearchAllService(
    BuildContext context,String keyword) async {
  final SearchAllResponseModel responseDto = SearchAllResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "search/$keyword", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
