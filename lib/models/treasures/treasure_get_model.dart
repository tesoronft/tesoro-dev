class TreasureGetModel {
  String? productId,
      userId,
      title,
      category,
      condition,
      brand,
      itemModel,
      type,
      description,
      createdAt,
      collectedBy,
      collectedAt;
  int? price, distance;
  List<dynamic>? photos;
  LocationModel? location;
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
      this.userId});
  factory TreasureGetModel.fromJson(Map<String, dynamic> jsonData) {
    return TreasureGetModel(
      brand: jsonData['brand'],
      category: jsonData['category'],
      condition: jsonData['condition'],
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
      userId: jsonData['user'],
    );
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
