import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/genres&mood/genre_model.dart';

class GetAllGenreAndMoodeResposenModel extends AbstractDto {
  List<GenreAndMoodeModel> genreAndMoodList = [];

  @override
  fromMap(Map<String, dynamic> map) {
    genreAndMoodList = (map['genreAndMoodList'] as List<dynamic>)
        .map((e) {
          GenreAndMoodeModel model = new GenreAndMoodeModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<GenreAndMoodeModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
