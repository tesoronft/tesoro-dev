import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider with ChangeNotifier {
  String? _accessToken, _refereshToken, _userId;
  bool _isDeleting = false;
  bool? _isSSOUser;
  bool get isDeleting => _isDeleting;
  String? get refreshToken => _refereshToken;
  String? get accessToken => _accessToken;
  String? get userId => _userId;
  bool? get isSSOUser => _isSSOUser;
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
    _isSSOUser = _prefs.getBool('isSSOUser') ?? false;
    log('accessToken:$_accessToken, refereshToken:$_refereshToken,userId:$userId, isSSOUser:$_isSSOUser');
    notifyListeners();
  }

  //Setters
  Future<void> setRefreshToken(String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refreshToken', refreshToken);
    log('Refresh token: $refreshToken');
    _refereshToken = refreshToken;
    notifyListeners();
  }

  Future<void> setAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    _accessToken = accessToken;
    log('Access token: $accessToken');
    notifyListeners();
  }

  Future<void> setIsSSOUser(bool isSSO) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSSOUser', isSSO);
    _isSSOUser = isSSO;
    log('Is SSO User: $isSSO');
    notifyListeners();
  }

  Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
    _userId = userId;
    log('UserId: $userId');
    notifyListeners();
  }

  Future<void> clearAllValues() async {
    _isDeleting = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _accessToken = '';
    _refereshToken = '';
    _userId = '';
    _isSSOUser = null;
    _isDeleting = false;
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
