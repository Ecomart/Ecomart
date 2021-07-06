class Prediction {
  String? description;
  String? placeId;
  late String lat;
  late String long;
  Prediction.fromJson(json) {
    description = json['description'];
    placeId = json['place_id'];
  }
  Prediction();
}
