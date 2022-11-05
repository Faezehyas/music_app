import 'package:ahanghaa/models/abstract_dto.dart';

class ChangeFavoriteStateResponseModel extends AbstractDto {
  bool is_favorited = false;

  @override
  fromMap(Map<String, dynamic> map) {
    this.is_favorited = map['is_favorited'];
  }

  @override
  Map<String, dynamic> toMap() => {'is_favorited': this.is_favorited};
}
