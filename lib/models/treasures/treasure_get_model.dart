class TreasureGetModel {
  String? productId,
      userId,
      title,
      brand,
      itemModel,
      type,
      description,
      collectedBy,
      collectedAt,
      createdAt;
  CategoryData? category;
  ConditionData? condition;
  dynamic price;
  dynamic distance;
  List<dynamic>? photos;
  LocationModel? location;
  PostedBy? postedBy;
  TreasureGetModel(
      {this.brand,
      this.category,
      this.condition,
      this.createdAt,
      this.collectedAt,
      this.collectedBy,
      this.description,
      this.distance,
      this.itemModel,
      this.location,
      this.photos,
      this.price,
      this.productId,
      this.title,
      this.type,
      this.userId,
      this.postedBy});
  factory TreasureGetModel.fromJson(Map<String, dynamic> jsonData) {
    return TreasureGetModel(
        brand: jsonData['brand'],
        category: CategoryData.fromJson(jsonData['category']),
        condition: ConditionData.fromJson(jsonData['condition']),
        createdAt: jsonData['createdAt'],
        collectedAt: jsonData['collectedAt'],
        collectedBy: jsonData['collectedBy'],
        description: jsonData['description'],
        distance: jsonData['distance'],
        itemModel: jsonData['itemModel'],
        location: LocationModel.fromJson(jsonData['location']),
        photos: jsonData['photos'] as List<dynamic>,
        price: jsonData['price'],
        productId: jsonData['_id'],
        title: jsonData['title'],
        type: jsonData['type'],
        userId: jsonData['_id'],
        postedBy: PostedBy.fromJson(jsonData['postedBy']));
  }
}

class CategoryData {
  String? id, name;
  CategoryData({this.id, this.name});
  factory CategoryData.fromJson(Map<String, dynamic> jsonData) {
    return CategoryData(
      id: jsonData['_id']?.toString(),
      name: jsonData['name']?.toString(),
    );
  }
  @override
  String toString() {
    return '''
id:$id,
name:$name, 
''';
  }
}

class ConditionData {
  String? id, name;
  ConditionData({this.id, this.name});
  factory ConditionData.fromJson(Map<String, dynamic> jsonData) {
    return ConditionData(
      id: jsonData['_id']?.toString(),
      name: jsonData['name']?.toString(),
    );
  }
  @override
  String toString() {
    return '''
id:$id,
name:$name, 
''';
  }
}

class LocationModel {
  String? type, address, placeId;
  List<dynamic>? coordinates;
  LocationModel({this.address, this.placeId, this.coordinates, this.type});
  factory LocationModel.fromJson(Map<String, dynamic> jsonData) {
    return LocationModel(
        address: jsonData['address'],
        coordinates: jsonData['coordinates'] as List<dynamic>,
        placeId: jsonData['placeId'],
        type: jsonData['type']);
  }

  @override
  String toString() {
    return '''
address:$address,
placeId:$placeId,
type:$type,
coordinates:$coordinates,
''';
  }
}

class PostedBy {
  String? id, name, profileImage;

  dynamic rating;
  PostedBy({this.id, this.name, this.profileImage, this.rating});
  factory PostedBy.fromJson(Map<String, dynamic> jsonData) {
    return PostedBy(
      id: jsonData['_id']?.toString(),
      name: jsonData['name']?.toString() ?? "Unknown",
      profileImage: jsonData['profileImage']?.toString() ?? '',
      rating: jsonData['rating'] ?? 0,
    );
  }
}
