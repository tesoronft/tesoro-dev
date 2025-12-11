import '../treasures/get_all_treasures_model.dart';
import 'received_tips_model.dart';

class SendedTipsResponse {
  List<ReceivedTipsModel> data;
  Pagination pagination;

  SendedTipsResponse({required this.data, required this.pagination});

  factory SendedTipsResponse.fromJson(Map<String, dynamic> json) {
    return SendedTipsResponse(
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
        receiverData: ReceiverData.fromJson(jsonData['receiverUser']),
        treasureData: TreasureData.fromJson(jsonData['treasure']));
  }
}
