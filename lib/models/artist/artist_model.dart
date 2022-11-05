import 'dart:io';

import 'package:ahanghaa/models/abstract_dto.dart';

class ArtistModel extends AbstractDto {
  int id = 0;
  String name_en = '';
  String name_fa = '';
  String display_name = '';
  // "bio": null,
  String profile_photo = '';
  // "spotify_url": null,
  // "tidal_url": null,
  // "html_banner": null,
  bool is_verified = false;
  bool is_followed = false;
  String? admob_id;
  int visitors = 0;
  int followers = 0;
  @override
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name_en = map['name_en'];
    name_fa = map['name_fa'];
    display_name = map['display_name'];
    profile_photo = map['profile_photo'];
    is_verified = map['is_verified'];
    is_followed = map['is_followed'] ?? false;
    visitors = map['visitors'];
    followers = map['followers'];
    admob_id = Platform.isAndroid
        ? (map['admob_android_id'])
        : (map['admob_ios_id']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_en': name_en,
      'name_fa': name_fa,
      'display_name': display_name,
      'profile_photo': profile_photo,
      'is_verified': is_verified,
      'is_followed': is_followed,
      'visitors': visitors,
      'followers': followers
    };
  }
}
