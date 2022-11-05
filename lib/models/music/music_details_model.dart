import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/artist/artist_model.dart';

class MusicDetailsModel extends AbstractDto {
  List<ArtistModel> singers = [];
  List<ArtistModel> lyricists = [];
  List<ArtistModel> composers = [];
  List<ArtistModel> arrangers = [];
  List<ArtistModel> mixers = [];
  @override
  fromMap(Map<String, dynamic> map) {
    singers = (map['singers'] as List<dynamic>)
        .map((e) {
          ArtistModel model = new ArtistModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<ArtistModel>()
        .toList();
    lyricists = (map['lyricists'] as List<dynamic>)
        .map((e) {
          ArtistModel model = new ArtistModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<ArtistModel>()
        .toList();
    composers = (map['composers'] as List<dynamic>)
        .map((e) {
          ArtistModel model = new ArtistModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<ArtistModel>()
        .toList();
    arrangers = (map['arrangers'] as List<dynamic>)
        .map((e) {
          ArtistModel model = new ArtistModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<ArtistModel>()
        .toList();
    mixers = (map['mixers'] as List<dynamic>)
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
    return {
      "singers": singers.map((e) => e.toMap()).toList(),
      "lyricists": lyricists.map((e) => e.toMap()).toList(),
      "composers": composers.map((e) => e.toMap()).toList(),
      "arrangers": arrangers.map((e) => e.toMap()).toList(),
      "mixers": mixers.map((e) => e.toMap()).toList()
    };
  }
}
