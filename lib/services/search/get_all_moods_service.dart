import 'package:ahanghaa/models/genres&mood/get_all_genre_moode_response_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/search/search_all_response_model.dart';
import 'package:ahanghaa/models/slider/get_sliders_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetAllMoodsService(
    BuildContext context) async {
  final GetAllGenreAndMoodeResposenModel responseDto = GetAllGenreAndMoodeResposenModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "moods", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null,useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
