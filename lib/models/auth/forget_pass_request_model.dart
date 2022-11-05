import 'package:ahanghaa/models/abstract_dto.dart';

class ForgetPassRequestModel extends AbstractDto {
  String email = '';
  String new_password = '';
  String otp = '';

  @override
  fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'new_password': this.new_password,
      'otp': this.otp
    };
  }
}
