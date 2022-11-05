import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/album/album_model.dart';

class GetLatestAlbumResponseModel extends AbstractDto {
  List<AlbumModel> albumList = [];

  @override
  fromMap(Map<String, dynamic> map) {
    albumList = (map['albumList'] as List<dynamic>)
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
