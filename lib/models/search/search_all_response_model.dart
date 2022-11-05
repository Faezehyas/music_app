import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';

class SearchAllResponseModel extends AbstractDto {
  List<ArtistModel> artists = [];
  List<MusicModel> musics = [];
  List<AlbumModel> albums = [];
  List<PodcastModel> podcasts = [];
  List<VideoModel> videos = [];
  List<UserModel> users = [];
  @override
  fromMap(Map<String, dynamic> map) {
    artists = (map['artists'] as List<dynamic>)
        .map((e) {
          ArtistModel model = new ArtistModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<ArtistModel>()
        .toList();
    musics = (map['musics'] as List<dynamic>)
        .map((e) {
          MusicModel model = new MusicModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<MusicModel>()
        .toList();
    albums = (map['albums'] as List<dynamic>)
        .map((e) {
          AlbumModel model = new AlbumModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<AlbumModel>()
        .toList();
    podcasts = (map['podcasts'] as List<dynamic>)
        .map((e) {
          PodcastModel model = new PodcastModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<PodcastModel>()
        .toList();
    videos = (map['videos'] as List<dynamic>)
        .map((e) {
          VideoModel model = new VideoModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<VideoModel>()
        .toList();
    users = (map['users'] as List<dynamic>)
        .map((e) {
          UserModel model = new UserModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<UserModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
