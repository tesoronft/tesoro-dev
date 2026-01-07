import 'package:tesoro_nft_app/models/treasures/get_all_treasures_model.dart';

class CategoryModelList {
  List<CategoryModel>? categoryModel;
  Pagination? pagination;
  CategoryModelList({this.categoryModel, this.pagination});
  factory CategoryModelList.fromJson(Map<String, dynamic> jsonData) {
    return CategoryModelList(
        categoryModel: (jsonData['categories'] as List<dynamic>)
            .map((category) => CategoryModel.fromJson(category))
            .toList(),
        pagination: Pagination.fromJson(jsonData['pagination']));
  }
}

class CategoryModel {
  String? id, user, name, description;
  CategoryModel({this.description, this.id, this.name, this.user});
  factory CategoryModel.fromJson(Map<String, dynamic> jsonData) {
    return CategoryModel(
      description: jsonData['description'],
      id: jsonData['_id'],
      name: jsonData['name'],
      user: jsonData['user'],
    );
  }
}
