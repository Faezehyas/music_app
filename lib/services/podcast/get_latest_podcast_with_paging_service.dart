import 'package:ahanghaa/models/podcast/get_podcast_list_response_model.dart';
import 'package:ahanghaa/services/service_caller.dart';
import 'package:flutter/material.dart';

Future<dynamic> GetLatestPodcastListWithPagingService(
    BuildContext context, int page, int limit) async {
  GetPodcastsListResponseModel responseDto = new GetPodcastsListResponseModel();
  final ServiceCaller serviceCaller = ServiceCaller(
      "podcasts/latest?page=$page&limit=$limit", responseDto, context,
      httpMethodEnum: HttpMethodEnum.GET, request: null, useDefaultHost: true);
  await serviceCaller.call();
  return serviceCaller.response;
}
