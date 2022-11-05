import 'package:ahanghaa/models/abstract_dto.dart';

class GetAdsResponseModel extends AbstractDto {
  String admob_android_id = '';
  String admob_ios_id = '';

  @override
  fromMap(Map<String, dynamic> map) {
    this.admob_android_id = map['admob_android_id'] ?? '';
    this.admob_ios_id = map['admob_ios_id'] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
