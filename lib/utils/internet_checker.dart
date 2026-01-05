import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class InternetChecker with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  late StreamSubscription _subscription;
  InternetChecker() {
    log('Internet connection checking started');
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      bool previous = _isConnected;
      _isConnected = result.first != ConnectivityResult.none;

      if (previous != _isConnected) {
        notifyListeners();
      }
    });
  }
}
