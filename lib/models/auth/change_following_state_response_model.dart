import 'package:ahanghaa/models/abstract_dto.dart';

class ChangeFollowingStateResponseModel extends AbstractDto{
  bool success = false;
  bool is_followed = false;

  @override
  fromMap(Map<String, dynamic> map) {
    this.success = map['success'];
    this.is_followed = map['is_followed'];
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
  
}