import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/models/auth/auth_model.dart';
import 'package:tesoro_nft_app/models/content/get_content_info_model.dart';
import 'package:tesoro_nft_app/models/tips/give_tips_model.dart';
import 'package:tesoro_nft_app/models/tips/received_tips_model.dart';
import 'package:tesoro_nft_app/models/treasures/get_all_treasures_model.dart';
import 'package:tesoro_nft_app/models/treasures/get_posted_treasure_model.dart';
import 'package:tesoro_nft_app/models/user/user_profile.dart';

import '../models/tips/sended_tips_model.dart';

class ApiProvider with ChangeNotifier {
  final String baseUrl = 'https://tesoro-app-production.up.railway.app/api';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _responseTxt = '';
  String get responseTxt => _responseTxt;
  GetAllTreasuresModel? _getAllTreasuresModel, _getUserTreasureModel;
  GetAllTreasuresModel? get getAllTreasureModel => _getAllTreasuresModel;
  GetAllTreasuresModel? get getUserTreasureModel => _getUserTreasureModel;
  GetContentInfoModel? _contentInfoModel;
  GetContentInfoModel? get contentInfoModel => _contentInfoModel;
  ContentInfo? _contentInfo;
  ContentInfo? get contentInfo => _contentInfo;
  AuthModel? _authModel;
  AuthModel? get authModel => _authModel;
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;
  GetAllCollectedTreasure? _allCollectedTreasure;
  GetAllCollectedTreasure? get allCollectedTreasure => _allCollectedTreasure;
  ReceivedTipsResponse? _receivedTipsModel;
  SendedTipsResponse? _giveTipsModel;
  SendedTipsResponse? get givenTipsModel => _giveTipsModel;
  ReceivedTipsResponse? get receivedTipsModel => _receivedTipsModel;
  Future<ApiEnums> createAccount(
      String userName, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https.post(Uri.parse('$baseUrl/auth/signup'),
          body: {"name": userName, "email": email, "password": password});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);

        log(json);
        _responseTxt = json['message'];
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  Future<ApiEnums> signInUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https.post(Uri.parse('$baseUrl/auth/login'),
          body: {"email": email, "password": password});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(response.body);
        _authModel = AuthModel.fromJson(json['data']);
        _responseTxt = json['message'];
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  Future<String> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https
          .post(Uri.parse('$baseUrl/auth/password'), body: {"email": email});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<ApiEnums> getUserData(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await https.post(Uri.parse('$baseUrl/users/me'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      log('here');
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(response.body);
        _userProfile = UserProfile.fromJson(json);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);

        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  Future<String> updateUserData(String token, String? email, String? name,
      String? newPassword, String? oldPassword, String uid) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await https.post(Uri.parse('$baseUrl/users/update'), body: {
        "userId": uid,
        "name": name,
        "currentPassword": oldPassword,
        "newPassword": newPassword,
      }, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https.post(Uri.parse('$baseUrl/auth/verify-otp'),
          body: {"email": email, 'otp': otp});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> resetPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https.post(
          Uri.parse('$baseUrl/auth/reset-password'),
          body: {"email": email, 'newPassword': password});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> getRefreshToken(String oldToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https.post(Uri.parse('$baseUrl/auth/refresh'),
          body: {"refreshToken": oldToken});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // Treasure Section
  Future<String> createTreasure() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await https.post(Uri.parse('$baseUrl/treasures/create'), body: {
        "title": "Gold Necklace",
        "location": {
          "address": "Clifton, Karachi, Pakistan",
          "lat": 24.8607,
          "lng": 67.0011,
          "placeId": "ChIJd_Y0eVIvkIARuQyDN0F1LBA"
        },
        "photos": [
          "https://example.com/photo1.jpg",
          "https://example.com/photo2.jpg"
        ],
        "price": 15000,
        "category": "69309587820eb12d63b8238b",
        "condition": "Used",
        "brand": "GulAhmed",
        "itemModel": "NA",
        "type": "Accessory",
        "description": "Beautiful gold necklace in excellent condition."
      });
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> getTreasureData(String treasureId) async {
    _isLoading = false;
    notifyListeners();
    try {
      final response = await https.post(Uri.parse('$baseUrl/treasures/detail'),
          body: {"treasureId": treasureId});
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> getAllTreasuresData(
    int page,
    int limit,
    String treasureScope,
    String longitude,
    String latitude,
    String distancePerKm,
    String token,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final uri = Uri.parse('$baseUrl/treasures/all').replace(
        queryParameters: {
          'page': '$page',
          'limit': '$limit',
          'scope': treasureScope,
          'longitude': longitude,
          'latitude': latitude,
          'distance': distancePerKm,
        },
      );

      final response = await https.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(response.body);
        _getAllTreasuresModel = GetAllTreasuresModel.fromJson(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> getPostedTreasuresData(
    int page,
    int limit,
    String token,
    String uid,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final uri = Uri.parse('$baseUrl/treasures/collected/user').replace(
        queryParameters: {
          'page': '$page',
          'limit': '$limit',
        },
      );

      final response = await https.post(uri, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'userId': uid
      });

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(response.body);
        _getUserTreasureModel = GetAllTreasuresModel.fromJson(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> updateTreasure(String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await https.post(Uri.parse('$baseUrl/treasures/update'), headers: {
        'Authorization': accessToken,
      }, body: {
        "treasureId": "6929da9a9290a2e5c4960c90",
        "title": "Ancient Silver Coin",
        "price": 3500,
        "location": {
          "address": "456 Park Avenue, New York, NY",
          "lat": 40.771133,
          "lng": -73.974187
        },
        "photos": ["https://your-s3-bucket-url.com/photo3.jpg"],
        "brand": "SilverMint",
        "condition": "Good"
      });
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> deleteTreasure(String treasureId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await https.post(Uri.parse('$baseUrl/treasures/delete'), headers: {
        'Authorization': accessToken,
      }, body: {
        "treasureId": treasureId
      });
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(json);
        _isLoading = false;
        notifyListeners();
        return json;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return response.reasonPhrase ?? response.statusCode.toString();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<ApiEnums> getTreasureCollectedByUser(
    int page,
    String token,
    String uid,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final uri = Uri.parse('$baseUrl/treasures/collected/user').replace(
        queryParameters: {
          'page': '$page',
          'limit': '10',
        },
      );

      final response = await https.post(
        uri,
        body: {
          'userId': uid,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(response.body);
        _allCollectedTreasure = GetAllCollectedTreasure.fromJson(json);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  // Tips
  Future<ApiEnums> createTips(
      GiveTipsModel tipsModel, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await https.post(Uri.parse('$baseUrl/tips/create'), headers: {
        'Authorization': 'Bearer $accessToken',
      }, body: {
        "givenUser": tipsModel.senderId,
        "receivedUser": tipsModel.receiverId,
        "treasure": tipsModel.treasureId,
        "amount": tipsModel.amount,
      });
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        log(response.body);
        _responseTxt = json['message'];
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  Future<ApiEnums> receivedTipdData(
      String uid, String accessToken, int page) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https.post(
          Uri.parse('$baseUrl/tips/received?page=$page&limit=15'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          body: {
            "userId": uid
          });
      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        log(response.body);
        _receivedTipsModel = ReceivedTipsResponse.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  Future<ApiEnums> givenTipsData(
      String uid, String accessToken, int page) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await https
          .post(Uri.parse('$baseUrl/tips/given?page=$page&limit=15'), headers: {
        'Authorization': 'Bearer $accessToken',
      }, body: {
        "userId": uid
      });
      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        log(response.body);

        _giveTipsModel = SendedTipsResponse.fromJson(jsonData);

        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  // settings
  Future<ApiEnums> getAppUrls(String accessToken) async {
    try {
      final response = await https
          .post(Uri.parse('$baseUrl/contents/all?page=1&limit=15'), headers: {
        'Authorization': 'Bearer $accessToken',
      });
      if (response.statusCode == 201) {
        log(response.body);
        final jsonData = jsonDecode(response.body);
        _contentInfoModel = GetContentInfoModel.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }

  Future<ApiEnums> getAppContent(String accessToken, String contentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await https.post(Uri.parse('$baseUrl/contents/detail'), body: {
        "contentId": contentId
      }, headers: {
        'Authorization': 'Bearer $accessToken',
      });
      if (response.statusCode == 201) {
        log(response.body);
        final jsonData = jsonDecode(response.body);
        _contentInfo = ContentInfo.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.success;
      } else {
        log(response.body);
        _isLoading = false;
        notifyListeners();
        return ApiEnums.failed;
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return ApiEnums.failed;
    }
  }
}
