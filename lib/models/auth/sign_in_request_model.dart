import 'package:ahanghaa/models/abstract_dto.dart';

class SignInRequestModel extends AbstractDto {
  String email = '';
  String password = '';
  String fcm_token = '';

  @override
  fromMap(Map<String, dynamic> map) {
    this.email = map['email'];
    this.password = map['password'];
    this.fcm_token = map['fcm_token'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'password': this.password,
      'fcm_token': this.fcm_token
    };
  }
}
