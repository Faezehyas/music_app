import 'dart:io';

import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';

class PodcastModel extends AbstractDto {
  int? id;
  String? title_en = '';
  String? title_fa = '';
  String? cover_photo_url = '';
  String? demo_url = '';
  String? full_url = '';
  String? others = '';
  // "spotify_url": null,
  // "tidal_url": null,
  bool? is_featured;
  String? lyrics = '';
  String? spotify_url = '';
  String? tidal_url = '';
  bool? is_favorited;
  bool? is_liked;
  int? likes;
  int? visitors;
  ArtistModel artist = new ArtistModel();
  String? filePath;
  String? imgPath;
  String? admob_id;

  @override
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title_en = map['title_en'];
    title_fa = map['title_fa'];
    cover_photo_url = map['cover_photo_url'];
    demo_url = map['demo_url'];
    full_url = map['full_url'];
    is_featured = map['is_featured'];
    lyrics = map['lyrics'];
    spotify_url = map['spotify_url'];
    tidal_url = map['tidal_url'];
    is_favorited = map['is_favorited'];
    is_liked = map['is_liked'];
    likes = map['likes'];
    admob_id = Platform.isAndroid
        ? (map['admob_android_id'])
        : (map['admob_ios_id']);
    visitors = map['visitors'];
    if (map['artist'] != null) {
      artist = new ArtistModel();
      artist.fromMap(map['artist'] as Map<String, dynamic>);
    }
    others = map['others'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_en': title_en,
      'title_fa': title_fa,
      'cover_photo_url': cover_photo_url,
      'demo_url': demo_url,
      'full_url': full_url,
      'is_featured': is_featured,
      'lyrics': lyrics,
      'spotify_url': spotify_url,
      'tidal_url': tidal_url,
      'is_favorited': is_favorited,
      'is_liked': is_liked,
      'likes': likes,
      'visitors': visitors,
      'artist': artist.toMap(),
      'others': others
    };
  }
}
