import 'package:tesoro_nft_app/models/treasures/get_all_treasures_model.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';

class GetAllCollectedTreasure {
  List<GetCollectedTreasureModel>? listOfPostedTreasures;
  Pagination? pagination;
  GetAllCollectedTreasure({this.listOfPostedTreasures, this.pagination});
  factory GetAllCollectedTreasure.fromJson(Map<String, dynamic> jsonData) {
    return GetAllCollectedTreasure(
      listOfPostedTreasures: (jsonData['data'] as List)
          .map((e) => GetCollectedTreasureModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(jsonData['pagination']),
    );
  }
}

class GetCollectedTreasureModel {
  String? treasureId, title, collectedAt;
  List<dynamic>? photos;
  Category? category;
  PostedBy? postedBy;
  LocationModel? locationModel;
  GetCollectedTreasureModel({
    this.category,
    this.collectedAt,
    this.locationModel,
    this.photos,
    this.postedBy,
    this.title,
    this.treasureId,
  });
  factory GetCollectedTreasureModel.fromJson(Map<String, dynamic> jsonData) {
    return GetCollectedTreasureModel(
      category: jsonData['category'],
      collectedAt: jsonData['collectedAt'],
      locationModel: jsonData['location'],
      photos: jsonData['photos'],
      postedBy: jsonData['postedBy'],
      title: jsonData['title'],
      treasureId: jsonData['_id'],
    );
  }
}

class Category {
  String? categoryId, cayegoryName;
  Category({this.categoryId, this.cayegoryName});
  factory Category.fromJson(Map<String, dynamic> jsonData) {
    return Category(
      categoryId: jsonData['_id'],
      cayegoryName: jsonData['name'],
    );
  }
}

class PostedBy {
  String? userId, userName, userEmail;
  PostedBy({this.userEmail, this.userId, this.userName});
  factory PostedBy.fromJson(Map<String, dynamic> jsonData) {
    return PostedBy(
      userEmail: jsonData['email'],
      userId: jsonData['_id'],
      userName: jsonData['name'],
    );
  }
}
