import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';

class GetAllTreasuresModel {
  List<TreasureGetModel>? allTreasuresData;
  Pagination? pagination;
  GetAllTreasuresModel({this.allTreasuresData, this.pagination});
  factory GetAllTreasuresModel.fromJson(Map<String, dynamic> jsondata) {
    return GetAllTreasuresModel(
      allTreasuresData: (jsondata['treasures'] as List<dynamic>)
          .map((data) => TreasureGetModel.fromJson(data))
          .toList(),
      pagination: Pagination.fromJson(jsondata['pagination']),
    );
  }
}

class Pagination {
  int? page, limit, total, totalPages;
  Pagination({this.limit, this.page, this.total, this.totalPages});
  factory Pagination.fromJson(Map<String, dynamic> jsonData) {
    return Pagination(
        limit: jsonData['limit'],
        page: jsonData['page'],
        total: jsonData['total'],
        totalPages: jsonData['totalPages']);
  }
  @override
  String toString() {
    return '''
limit:$limit,page:$page,total:$total,totalPages:$totalPages,
''';
  }
}
