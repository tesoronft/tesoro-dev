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
  @override
  String toString() {
    return 'GetAllCollectedTreasure(listOfPostedTreasures: $listOfPostedTreasures, pagination: $pagination)';
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
      category: Category.fromJson(jsonData['category'] ?? {}),
      collectedAt: jsonData['collectedAt'],
      locationModel: LocationModel.fromJson(jsonData['location']),
      photos: jsonData['photos'],
      postedBy: PostedBy.fromJson(jsonData['postedBy']),
      title: jsonData['title'],
      treasureId: jsonData['_id'],
    );
  }
  @override
  String toString() {
    return 'GetCollectedTreasureModel(treasureId: $treasureId, title: $title, collectedAt: $collectedAt, photos: $photos, category: $category, postedBy: $postedBy, locationModel: $locationModel)';
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
  @override
  String toString() {
    return 'Category(categoryId: $categoryId, cayegoryName: $cayegoryName)';
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
  @override
  String toString() {
    return 'PostedBy(userId: $userId, userName: $userName, userEmail: $userEmail)';
  }
}
