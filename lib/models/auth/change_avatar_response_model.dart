import 'package:ahanghaa/models/abstract_dto.dart';

class ChangeAvatarResponseModel extends AbstractDto {
  bool success = false;
  String avatar = '';

  @override
  fromMap(Map<String, dynamic> map) {
    this.success = map['success'];
    this.avatar = map['avatar'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {'success': this.success, 'avatar': this.avatar};
  }
}
