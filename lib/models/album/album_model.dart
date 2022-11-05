import 'dart:io';

import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';

class AlbumModel extends AbstractDto {
  int id = 0;
  String title_en = '';
  String title_fa = '';
  String cover_photo_url = '';
  bool is_featured = false;
  bool is_favorited = false;
  String? admob_id;
  ArtistModel artist = new ArtistModel();
  List<MusicModel> musics = [];

  @override
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title_en = map['title_en'];
    title_fa = map['title_fa'];
    cover_photo_url = map['cover_photo_url'];
    is_featured = map['is_featured'];
    this.is_favorited = map['is_favorited'] ?? false;
    admob_id = Platform.isAndroid
        ? (map['admob_android_id'])
        : (map['admob_ios_id']);
    if (map['artist'] != null) {
      artist.fromMap(map['artist']);
    }
    if (map['musics'] != null) {
      musics = (map['musics'] as List<dynamic>)
          .map((e) {
            MusicModel model = new MusicModel();
            model.fromMap(e as Map<String, dynamic>);
            model.artists.singers.add(this.artist);
            return model;
          })
          .cast<MusicModel>()
          .toList();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_en': title_en,
      'title_fa': title_fa,
      'cover_photo_url': cover_photo_url,
      'is_featured': is_featured,
      'is_favorited': this.is_favorited,
      'artist': artist.toMap()
    };
  }
}
