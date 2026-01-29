import 'dart:async';
import 'dart:developer';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/widgets.dart';

class InternetChecker extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late final InternetConnectionChecker _checker;
  StreamSubscription<InternetConnectionStatus>? _subscription;

  InternetChecker() {
    log('InternetChecker constructor');
    _checker = InternetConnectionChecker.createInstance();
    _init();
  }
  Future<bool> checkConnection() async {
    _isConnected = await _checker.hasConnection;
    log('Manual check - Internet connected: $_isConnected');
    notifyListeners();
    return _isConnected;
  }

  Future<void> _init() async {
    _isConnected = await _checker.hasConnection;
    notifyListeners();

    _subscription = _checker.onStatusChange.listen((status) {
      log('Internet status: $status');

      _isConnected = status == InternetConnectionStatus.connected;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
