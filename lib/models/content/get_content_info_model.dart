import 'package:tesoro_nft_app/models/treasures/get_all_treasures_model.dart';

class GetContentInfoModel {
  List<Item>? items;
  Pagination? pagination;
  GetContentInfoModel({this.items, this.pagination});
  factory GetContentInfoModel.fromJson(Map<String, dynamic> jsonData) {
    return GetContentInfoModel(
        items: (jsonData['items'] as List<dynamic>)
            .map((data) => Item.fromJson(data))
            .toList(),
        pagination: jsonData['pagination']);
  }
}

class Item {
  String? id, name, createdAt;
  Item({this.createdAt, this.id, this.name});
  factory Item.fromJson(Map<String, dynamic> jsonData) {
    return Item(
        createdAt: jsonData['createdAt'],
        id: jsonData['_id'],
        name: jsonData['name']);
  }
}

class ContentInfo {
  String? id, name, content;
  ContentInfo({this.content, this.id, this.name});
  factory ContentInfo.fromJson(Map<String, dynamic> jsonData) {
    return ContentInfo(
      content: jsonData['content'],
      id: jsonData['_id'],
      name: jsonData['name'],
    );
  }
}
