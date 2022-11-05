import 'package:ahanghaa/models/abstract_dto.dart';

class GenreAndMoodeModel extends AbstractDto {
  int? id;
  String? name_fa;
  String? name_en;
  String? image;
  
  @override
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name_fa = map['name_fa'];
    name_en = map['name_en'];
    image = map['image'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 0,
      'name_fa': name_fa,
      'name_en': name_en,
      'image': image
    };
  }
}
