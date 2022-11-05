import 'dart:io';

import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/music/music_details_model.dart';

class VideoModel extends AbstractDto {
  int? id;
  String? title_en = '';
  String? title_fa = '';
  String? cover_photo_url = '';
  String? normal_quality_url = '';
  String? high_quality_url = '';
  String? low_quality_url = '';
  String? admob_id;
  bool? is_featured;
  bool? is_favorited;
  bool? is_liked;
  int? likes;
  int? visitors;
  Duration currentDuration = Duration(seconds: 0);
  int quality = 0;
  int qualityCount = 0;
  MusicDetailsModel artists = new MusicDetailsModel();
  @override
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title_en = map['title_en'];
    title_fa = map['title_fa'];
    cover_photo_url = map['cover_photo_url'];
    normal_quality_url = map['normal_quality_url'];
    high_quality_url = map['high_quality_url'];
    low_quality_url = map['low_quality_url'];
    is_featured = map['is_featured'];
    is_favorited = map['is_favorited'];
    is_liked = map['is_liked'];
    likes = map['likes'];
    visitors = map['visitors'];
    admob_id = Platform.isAndroid
        ? (map['admob_android_id'])
        : (map['admob_ios_id']);
    if (map['artists'] != null) {
      artists = new MusicDetailsModel();
      artists.fromMap(map['artists'] as Map<String, dynamic>);
    }
    qualityCount = (low_quality_url != null &&
          normal_quality_url != null &&
          high_quality_url != null)
      ? 3
      : ((low_quality_url != null && normal_quality_url != null) 
      || (low_quality_url != null && high_quality_url != null) 
      || (normal_quality_url != null && high_quality_url != null))
      ? 2 : 1;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_en': title_en,
      'title_fa': title_fa,
      'cover_photo_url': cover_photo_url,
      'normal_quality_url': normal_quality_url,
      'high_quality_url': high_quality_url,
      'low_quality_url': low_quality_url,
      'is_featured': is_featured,
      'is_liked': is_liked,
      'likes': likes,
      'visitors': visitors,
      'artists': artists.toMap()
    };
  }
}
