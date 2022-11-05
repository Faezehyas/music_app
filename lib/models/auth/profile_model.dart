import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';
import 'package:ahanghaa/models/auth/user_model.dart';
import 'package:ahanghaa/models/music/music_model.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';

class ProfileModel extends AbstractDto {
  String name = '';
  String username = '';
  String avatar = '';
  bool is_online = false;
  bool is_artist = false;
  bool is_premium = false;
  MusicModel listening = new MusicModel();
  List<MusicModel> recentMusics = [];
  List<UserModel> followers = [];
  List<UserModel> followings = [];
  List<PlayListModel> playlists = [];
  List<ArtistModel> artists = [];

  @override
  fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.username = map['username'];
    this.avatar = (map['avatar'] != null && map['avatar'] != 'https://www.ahanghaa.com/images/default-avatar.png') ? map['avatar'] : '' ;
    this.is_online = map['is_online'];
    this.is_artist = map['is_artist'];
    this.is_premium = map['is_premium'];
    if (map['listening'] != null && map['listening'].toString().isNotEmpty) {
      listening = new MusicModel();
      listening.fromMap(map['listening'] as Map<String, dynamic>);
    }
    if (map['recentMusics'] != null) {
      recentMusics = (map['recentMusics'] as List<dynamic>)
          .map((e) {
            MusicModel model = new MusicModel();
            model.fromMap(e as Map<String, dynamic>);
            return model;
          })
          .cast<MusicModel>()
          .toList();
    }
    if (map['followers'] != null) {
      followers = (map['followers'] as List<dynamic>)
          .map((e) {
            UserModel model = new UserModel();
            model.fromMap(e as Map<String, dynamic>);
            return model;
          })
          .cast<UserModel>()
          .toList();
    }
    if (map['followings'] != null) {
      followings = (map['followings'] as List<dynamic>)
          .map((e) {
            UserModel model = new UserModel();
            model.fromMap(e as Map<String, dynamic>);
            return model;
          })
          .cast<UserModel>()
          .toList();
    }
    if (map['playlists'] != null) {
      playlists = (map['playlists'] as List<dynamic>)
          .map((e) {
            PlayListModel model = new PlayListModel();
            model.fromMap(e as Map<String, dynamic>);
            return model;
          })
          .cast<PlayListModel>()
          .toList();
    }
    if (map['artists'] != null) {
      artists = (map['artists'] as List<dynamic>)
          .map((e) {
            ArtistModel model = new ArtistModel();
            model.fromMap(e as Map<String, dynamic>);
            return model;
          })
          .cast<ArtistModel>()
          .toList();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
