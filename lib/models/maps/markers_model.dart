import 'package:tesoro_nft_app/models/treasures/get_all_treasures_model.dart';

class AllMarkers {
  List<MarkersModel>? markersModel;
  Pagination? pagination;
  AllMarkers({this.markersModel, this.pagination});
  factory AllMarkers.fromJson(Map<String, dynamic> jsonData) {
    return AllMarkers(
        markersModel: (jsonData['markers'] as List<dynamic>)
            .map((marker) => MarkersModel.fromJson(marker))
            .toList(),
        pagination: Pagination.fromJson(jsonData['pagination']));
  }
  @override
  String toString() {
    return '''
allMarkers:$markersModel,
pagination: $pagination,
''';
  }
}

class MarkersModel {
  String? id;
  List<dynamic>? coordinated;
  MarkersModel({this.coordinated, this.id});
  factory MarkersModel.fromJson(Map<String, dynamic> jsonData) {
    return MarkersModel(
      coordinated: jsonData['coordinates'],
      id: jsonData['_id'],
    );
  }
  @override
  String toString() {
    return '''
id:$id,
coordinates: $coordinated,
''';
  }
}
