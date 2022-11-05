import 'package:ahanghaa/models/abstract_dto.dart';
import 'package:ahanghaa/models/slider/slider_model.dart';

class GetSlidersResponseModel extends AbstractDto {
  late List<SliderModel> Sliders = [];

  @override
  fromMap(Map<String, dynamic> map) {
    Sliders = (map['sliders'] as List<dynamic>)
        .map((e) {
          SliderModel model = new SliderModel();
          model.fromMap(e as Map<String, dynamic>);
          return model;
        })
        .cast<SliderModel>()
        .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
