import 'dart:io';

import 'package:ahanghaa/models/abstract_dto.dart';

class CreatePlaylistRequestModel extends AbstractDto {
  String name = '';
  File? cover;
  bool is_visible = false;

  @override
  fromMap(Map<String, dynamic> map) {}

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cover': cover != null ? cover!.path : '',
      'is_visible': this.is_visible ? '1' : '0',
    };
  }
}
