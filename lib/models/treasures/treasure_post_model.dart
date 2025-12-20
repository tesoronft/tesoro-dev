class TreasurePostModel {
  String? title;
  String? category;
  String? condition;
  String? brand;
  String? itemModel;
  String? type;
  String? description;
  int? price;
  List<String>? photos;
  Location? location;

  TreasurePostModel({
    this.title,
    this.category,
    this.condition,
    this.brand,
    this.itemModel,
    this.type,
    this.description,
    this.price,
    this.photos,
    this.location,
  });
  TreasurePostModel copyWith({
    String? title,
    String? category,
    String? condition,
    String? brand,
    String? itemModel,
    String? type,
    String? description,
    int? price,
    List<String>? photos,
    Location? location,
  }) {
    return TreasurePostModel(
      title: title ?? this.title,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      brand: brand ?? this.brand,
      itemModel: itemModel ?? this.itemModel,
      type: type ?? this.type,
      description: description ?? this.description,
      price: price ?? this.price,
      photos: photos ?? this.photos,
      location: location ?? this.location,
    );
  }
}

class Location {
  String? type, address, placeId;
  List<double>? coordinates;
}
