import 'dart:convert';
import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

enum HttpMethodEnum { GET, POST, PUT, DELETE, MULTIPART }

class ServiceCaller<Request extends AbstractDto, Response extends AbstractDto> {
  final String uri;
  Request? request;
  late final HttpMethodEnum httpMethod;
  final BuildContext context;
  Response? response;
  late int responseCode;
  bool useDefaultHost;

  static String baseUrl = 'https://www.ahanghaa.com/api/v1/';

  ServiceCaller(this.uri, this.response, this.context,
      {required this.request,
      required HttpMethodEnum httpMethodEnum,
      required bool useDefaultHost})
      : httpMethod = httpMethodEnum,
        useDefaultHost = true;

  Future<void> call() async {
    MainProvider mainProvider = new MainProvider();
    if (await mainProvider.checkInternet(context)) {
      Map<String, String> headers = {
        "Authorization": UserInfos.getToken(context) ?? "",
        "Content-Type": "application/json",
        'Accept-Encoding': 'application/javascript'
      };

      http.Response? response;
      try {
        switch (this.httpMethod) {
          case HttpMethodEnum.GET:
            response = await http.get(
                Uri.parse(
                    (useDefaultHost ? ServiceCaller.baseUrl : "") + this.uri),
                headers: headers);
            break;
          case HttpMethodEnum.DELETE:
            response = await http.delete(
                Uri.parse((this.useDefaultHost ? ServiceCaller.baseUrl : "") +
                    this.uri),
                headers: headers);
            break;
          case HttpMethodEnum.POST:
            {
              response = await http.post(
                  Uri.parse((this.useDefaultHost ? ServiceCaller.baseUrl : "") +
                      this.uri),
                  headers: headers,
                  body: this.request != null
                      ? jsonEncode((this.request!).toMap())
                      : jsonEncode({}));
            }
            break;
          case HttpMethodEnum.PUT:
            response = await http.put(
                Uri.parse((this.useDefaultHost ? ServiceCaller.baseUrl : "") +
                    this.uri),
                headers: headers,
                body: jsonEncode((this.request!).toMap()));
            break;
          case HttpMethodEnum.MULTIPART:
            var httpRequest =
                http.MultipartRequest('POST', Uri.parse(this.uri));
            if (this.uri == "https://www.ahanghaa.com/api/v1/user-playlists" &&
                request!.toMap()['cover'] != null &&
                request!.toMap()['cover'] != '') {
              var multipartFile = await http.MultipartFile.fromPath(
                  "cover", request!.toMap()['cover']);
              httpRequest.fields['name'] = request!.toMap()['name'];
              httpRequest.fields['is_visible'] = request!.toMap()['is_visible'];
              httpRequest.files.add(multipartFile);
            } else if (this.uri ==
                    "https://www.ahanghaa.com/api/v1/auth/change-avatar" &&
                request!.toMap()['avatar'] != null &&
                request!.toMap()['avatar'] != '') {
              var multipartFile = await http.MultipartFile.fromPath(
                  "avatar", request!.toMap()['avatar']);
              httpRequest.files.add(multipartFile);
            } else {
              if (request != null)
                request!.toMap().forEach((key, value) {
                  httpRequest.fields[key] = value.toString();
                });
            }
            httpRequest.headers.addAll(headers);
            http.StreamedResponse httpResponse = await httpRequest.send();
            response = await http.Response.fromStream(httpResponse);
            break;
        }
      } catch (e) {
        ShowMessage('something went wrong!!', context);
      }

      try {
        if (this.uri != 'auth/sync') {
          if (response!.statusCode == 200 && response.bodyBytes.length > 0) {
            responseCode = response.statusCode;
            var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
            if (this.uri == "slides") {
              var resMap = {'sliders': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri.contains('musics/latest') ||
                this.uri.contains('genres/') ||
                this.uri.contains('moods/') ||
                this.uri.contains('musics/masters') ||
                this.uri.contains('top-tracks') ||
                this.uri == 'play-logs/recently' ||
                this.uri == 'musics/featured') {
              var resMap = {'musicList': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri == 'podcasts/featured' ||
                this.uri.contains('podcasts/latest')) {
              var resMap = {'podcastsList': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri.contains('albums/latest') ||
                this.uri == 'albums/featured') {
              var resMap = {'albumList': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri == 'videos/featured' ||
                this.uri.contains('videos/latest?page')) {
              var resMap = {'videoList': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri.contains('playlists?page') ||
                this.uri == "playlists/featured" ||
                this.uri == 'user-playlists/deleted' ||
                (this.uri.contains('user-playlists') &&
                    httpMethod == HttpMethodEnum.GET &&
                    !this.uri.contains('user-playlists/'))) {
              var resMap = {'playlists': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri == 'following') {
              var resMap = {'artistList': responseJson};
              this.response!.fromMap(resMap);
            } else if (this.uri == 'genres' || this.uri == 'moods') {
              var resMap = {'genreAndMoodList': responseJson};
              this.response!.fromMap(resMap);
            } else {
              this.response!.fromMap(responseJson);
            }
          } else if (response.statusCode == 409) {
            if (this.uri.contains('auth/signup'))
              ShowMessage('Username or email already exist!', context);
          } else if (response.statusCode == 400) {
            // Map<String, dynamic> responseJson =
            //     jsonDecode(utf8.decode(response.bodyBytes));
            // BaseResponseDto baseResponseDto = new BaseResponseDto();
            // baseResponseDto.fromMap(responseJson);
          } else if (response.statusCode == 404) {
            // switch (this.uri) {
            //   case "Account/Login":
            //     CustomModal.showInfo(context, "user does not exist");
            //     break;
            //   default:
            //     CustomModal.showError(
            //         context, "something went wrong , try again leter");
            // }
          } else if (response.statusCode == 403) {
            ShowMessage('email or password is incorrect', context);
          } else {
            ShowMessage('something went wrong!!', context);
          }
        }
      } catch (e) {
      }
    }
  }
}
