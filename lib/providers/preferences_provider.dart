import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider with ChangeNotifier {
  String? _accessToken, _refereshToken, _userId;
  String? get refreshToken => _refereshToken;
  String? get accessToken => _accessToken;
  String? get userId => _userId;

  PreferencesProvider() {
    log('Getting all preferences');
    getAllPrefs();
  }

  // Main Function
  Future<void> getAllPrefs() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _refereshToken = await getRefreshToken();
    _accessToken = await getAccessToken();
    _userId = _prefs.getString('userId') ?? '';
    log('accessToken:$_accessToken, refereshToken:$_refereshToken,userId:$userId');
    notifyListeners();
  }

  //Setters
  Future<void> setRefreshToken(String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refreshToken', refreshToken);
    log(refreshToken);
    notifyListeners();
  }

  Future<void> setAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    log(accessToken);
    notifyListeners();
  }

  Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
    _userId = userId;
    log(userId);
    notifyListeners();
  }

  //Getters
  Future<String> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken') ?? '';
  }

  Future<String> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }
}
