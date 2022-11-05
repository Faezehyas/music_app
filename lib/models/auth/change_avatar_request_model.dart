import 'dart:io';
import 'package:ahanghaa/models/abstract_dto.dart';

class ChangeAvatarRequestModel extends AbstractDto {
  File? avatar;

  @override
  fromMap(Map<String, dynamic> map) {}

  @override
  Map<String, dynamic> toMap() {
    return {
      'avatar' : avatar != null ? avatar!.path : ''
    };
  }
}
