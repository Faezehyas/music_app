import 'dart:io';

import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/music/music_model.dart';

class PlayListModel extends AbstractDto {
  int id = 0;
  int user_id = 0;
  String user_name = '';
  String name = '';
  String description = '';
  String cover_photo = '';
  bool is_featured = false;
  bool is_visible = false;
  String permalink = '';
  int music_count = 0;
  int visitors = 0;
  bool is_liked = false;
  bool is_favorited = false;
  int likes = 0;
  String? admob_id;
  List<MusicModel> musics = [];

  @override
  fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.user_id = map['user_id'];
    this.user_name = map['user_name'];
    this.name = map['name'];
    this.description = map['description'] ?? '';
    this.cover_photo = map['cover_photo'];
    this.is_featured = map['is_featured'] ?? false;
    this.is_visible = map['is_visible'] ?? false;
    this.permalink = map['permalink'];
    this.music_count = map['music_count'] ?? 0;
    this.visitors = map['visitors'];
    this.is_liked = map['is_liked'] ?? false;
    this.is_favorited = map['is_favorited'] ?? false;
    this.likes = map['likes'] ?? 0;
    admob_id = Platform.isAndroid
        ? (map['admob_android_id'])
        : (map['admob_ios_id']);
    if (map['musics'] != null)
      musics = (map['musics'] as List<dynamic>)
          .map((e) {
            MusicModel model = new MusicModel();
            model.fromMap(e as Map<String, dynamic>);
            return model;
          })
          .cast<MusicModel>()
          .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'user_id': this.user_id,
      'is_liked': this.is_liked,
      'is_favorited': this.is_favorited,
      'likes': this.likes,
      'user_name': this.user_name,
      'name': this.name,
      'description': this.description,
      'cover_photo': this.cover_photo,
      'is_featured': this.is_featured,
      'is_visible': this.is_visible,
      'permalink': this.permalink,
      'music_count': this.music_count,
      'visitors': this.visitors
    };
  }
}
