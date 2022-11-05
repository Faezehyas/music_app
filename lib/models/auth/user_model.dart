import 'package:ahanghaa/models/abstract_dto.dart';

class UserModel extends AbstractDto {
  int id = 0;
  String name = '';
  String? username;
  String email = '';
  String avatar = '';
  bool is_artist = false;
  String api_token = '';
  
  @override
  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.name = map['name'] ?? '';
    this.username = map['username'] ?? '';
    this.email = map['email'] ?? '';
    this.avatar = (map['avatar'] != null && map['avatar'] != 'https://www.ahanghaa.com/images/default-avatar.png') ? map['avatar'] : '' ;
    this.is_artist = map['is_artist'] ?? '';
    this.api_token = map['api_token'] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'username' : this.username ?? '',
      'email': this.email,
      'avatar': this.avatar,
      'is_artist': this.is_artist,
      'api_token': this.api_token
    };
  }
}
