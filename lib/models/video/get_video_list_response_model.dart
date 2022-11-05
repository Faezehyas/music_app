import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/video/video_model.dart';

class GetVideoListResponseModel extends AbstractDto {
  List<VideoModel> videoList = [];

  @override
  fromMap(Map<String, dynamic> map) {
    videoList = (map['videoList'] as List<dynamic>)
        .map((e) {
          VideoModel model = new VideoModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<VideoModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
