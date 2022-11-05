import 'package:ahanghaa/models/abstract_dto.dart';

class SliderModel extends AbstractDto {
  late String title;
  late String slidable_type;
  late int slidable_id;
  late String cover_photo;
  String singer_name = '';
  String song_name = '';
  bool is_verified = false;

  @override
  fromMap(Map<String, dynamic> map) {
    title = map['title'];
    slidable_type = map['slidable_type'];
    slidable_id = map['slidable_id'];
    cover_photo = map['cover_photo'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'slidable_type': slidable_type,
      'slidable_id': slidable_id,
      'cover_photo': cover_photo
    };
  }
}
