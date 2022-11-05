import 'dart:io';
import 'dart:typed_data';

import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/genres&mood/genre_model.dart';
import 'package:ahanghaa/models/music/music_details_model.dart';

class MusicModel extends AbstractDto {
  int? id;
  String? title_en = '';
  String? title_fa = '';
  String? cover_photo_url = '';
  String? normal_quality_url = '';
  String? high_quality_url = '';
  String? master_quality_url = '';
  String? others = '';
  bool? is_featured;
  String? lyrics = '';
  String? spotify_url = '';
  String? tidal_url = '';
  bool? is_favorited;
  bool? is_liked;
  int? likes;
  int visitors = 0;
  GenreAndMoodeModel genre = new GenreAndMoodeModel();
  GenreAndMoodeModel mood = new GenreAndMoodeModel();
  String? admob_id;
  MusicDetailsModel artists = new MusicDetailsModel();
  String? filePath;
  String? imgPath;
  File? file;
  int downloadedProgress = 0;
  int maxSize = 0;
  bool downloading = false;
  bool isPodcast = false;

  @override
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title_en = map['title_en'];
    title_fa = map['title_fa'];
    cover_photo_url = map['cover_photo_url'];
    normal_quality_url = map['normal_quality_url'];
    high_quality_url = map['high_quality_url'];
    master_quality_url = map['master_quality_url'];
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
    if (map['mood'] != null && map['mood'].toString().isNotEmpty) {
      mood = new GenreAndMoodeModel();
      mood.fromMap(map['mood'] as Map<String, dynamic>);
    }
    if (map['genre'] != null && map['genre'].toString().isNotEmpty) {
      genre = new GenreAndMoodeModel();
      genre.fromMap(map['genre'] as Map<String, dynamic>);
    }
    if (map['artists'] != null) {
      artists = new MusicDetailsModel();
      artists.fromMap(map['artists'] as Map<String, dynamic>);
    }
    isPodcast = map['isPodcast'] ?? false;
    others = map['others'];
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
      'master_quality_url': master_quality_url,
      'is_featured': is_featured,
      'lyrics': lyrics,
      'spotify_url': spotify_url,
      'tidal_url': tidal_url,
      'is_favorited': is_favorited,
      'is_liked': is_liked,
      'likes': likes,
      'visitors': visitors,
      'genre': genre.id != null ? genre.toMap() : '',
      'mood': mood.id != null ? mood.toMap() : '',
      'artists': artists.toMap(),
      'isPodcast': isPodcast,
      'others': others
    };
  }
}
