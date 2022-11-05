import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/music/music_model.dart';

class GetMusicListResponseModel extends AbstractDto {
  List<MusicModel> musicList = [];

  @override
  fromMap(Map<String, dynamic> map) {
    musicList = (map['musicList'] as List<dynamic>)
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
    return {};
  }
}
