import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';

class GetFavoriteArtistResponseModel extends AbstractDto{
  
  List<ArtistModel> artistList = [];

  @override
  fromMap(Map<String, dynamic> map) {
    artistList = (map['artistList'] as List<dynamic>)
        .map((e) {
          ArtistModel model = new ArtistModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<ArtistModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}