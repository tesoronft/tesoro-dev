import 'package:tesoro_nft_app/models/treasures/get_all_treasures_model.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';

class ReceivedTipsResponse {
  List<ReceivedTipsModel> data;
  Pagination pagination;

  ReceivedTipsResponse({required this.data, required this.pagination});

  factory ReceivedTipsResponse.fromJson(Map<String, dynamic> json) {
    return ReceivedTipsResponse(
      data: (json['data'] as List)
          .map((e) => ReceivedTipsModel.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class ReceivedTipsModel {
  int? amount;
  String? createdAt;
  ReceiverData? receiverData;
  TreasureData? treasureData;

  ReceivedTipsModel(
      {this.amount, this.createdAt, this.receiverData, this.treasureData});
  factory ReceivedTipsModel.fromJson(Map<String, dynamic> jsonData) {
    return ReceivedTipsModel(
        amount: jsonData['amount'],
        createdAt: jsonData['createdAt'],
        receiverData: ReceiverData.fromJson(jsonData['givenUser']),
        treasureData: TreasureData.fromJson(jsonData['treasure']));
  }
}

class ReceiverData {
  String? id, name, email;
  ReceiverData({this.email, this.id, this.name});
  factory ReceiverData.fromJson(Map<String, dynamic> jsonData) {
    return ReceiverData(
        email: jsonData['email'], id: jsonData['_id'], name: jsonData['name']);
  }
}

class TreasureData {
  String? id, title;
  LocationModel? locationModel;
  TreasureData({this.id, this.locationModel, this.title});
  factory TreasureData.fromJson(Map<String, dynamic> jsonData) {
    return TreasureData(
      id: jsonData['_id'],
      locationModel: LocationModel.fromJson(jsonData['location']),
      title: jsonData['title'],
    );
  }
}
