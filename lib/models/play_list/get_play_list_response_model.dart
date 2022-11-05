import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/play_list/play_list_model.dart';

class GetPlayListResponseModel extends AbstractDto {
  List<PlayListModel> playlists = [];

  @override
  fromMap(Map<String, dynamic> map) {
    playlists = (map['playlists'] as List<dynamic>)
        .map((e) {
          PlayListModel model = new PlayListModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<PlayListModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
