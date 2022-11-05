import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/album/album_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';
import 'package:ahanghaa/models/video/video_model.dart';

class GetFavoriteListResponseModel extends AbstractDto {
  List<MusicModel> musics = [];
  List<PodcastModel> podcasts = [];
  List<VideoModel> videos = [];
  List<PlayListModel> playlists = [];
  List<AlbumModel> albumlists = [];

  @override
  fromMap(Map<String, dynamic> map) {
    musics = (map['musics'] as List<dynamic>)
        .map((e) {
          MusicModel model = new MusicModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<MusicModel>()
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
    playlists = (map['playlists'] as List<dynamic>)
        .map((e) {
          PlayListModel model = new PlayListModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<PlayListModel>()
        .toList();
    albumlists = (map['albums'] as List<dynamic>)
        .map((e) {
          AlbumModel model = new AlbumModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<AlbumModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
