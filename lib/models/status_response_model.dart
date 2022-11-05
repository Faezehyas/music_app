import 'package:ahanghaa/models/abstract_dto.dart';

class StatusResponseModel extends AbstractDto {
  bool success = false;
  @override
  fromMap(Map<String, dynamic> map) {
    this.success = map['success'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {'success': this.success};
  }
}
