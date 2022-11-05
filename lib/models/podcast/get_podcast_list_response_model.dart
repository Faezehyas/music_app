import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/podcast/padcast_model.dart';

class GetPodcastsListResponseModel extends AbstractDto {
  
  List<PodcastModel> podcastsList = [];

  @override
  fromMap(Map<String, dynamic> map) {
    podcastsList = (map['podcastsList'] as List<dynamic>)
        .map((e) {
          PodcastModel model = new PodcastModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<PodcastModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
