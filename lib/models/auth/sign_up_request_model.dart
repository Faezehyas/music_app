import 'package:ahanghaa/models/abstract_dto.dart';

class SignUpRequestModel extends AbstractDto {
  String name = '';
  String? username;
  String email = '';
  String password = '';
  String fcm_token = '';

  @override
  fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.username = map['username'] ?? '';
    this.email = map['email'];
    this.password = map['password'];
    this.fcm_token = map['fcm_token'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'username': this.username ?? '',
      'email': this.email,
      'password': this.password,
      'fcm_token': this.fcm_token
    };
  }
}
