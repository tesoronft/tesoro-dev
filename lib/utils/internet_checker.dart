// import 'dart:async';
// import 'dart:developer';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:flutter/widgets.dart';

// class InternetChecker extends ChangeNotifier {
//   bool _isConnected = true;
//   bool get isConnected => _isConnected;

//   late final InternetConnectionChecker _checker;
//   StreamSubscription<InternetConnectionStatus>? _subscription;

//   InternetChecker() {
//     log('🟢 [INTERNET] InternetChecker constructor called');
//     log('InternetChecker constructor');
//     _checker = InternetConnectionChecker.createInstance();
//     log('🟢 [INTERNET] InternetConnectionChecker instance created');
//     _init().then((_) {
//       log('🟢 [INTERNET] _init() completed');
//     }).catchError((e) {
//       log('🟢 [INTERNET] _init() ERROR: $e');
//     });
//   }
//   Future<bool> checkConnection() async {
//     _isConnected = await _checker.hasConnection;
//     log('Manual check - Internet connected: $_isConnected');
//     notifyListeners();
//     return _isConnected;
//   }

//   Future<void> _init() async {
//     log('🟢 [INTERNET] _init() started');
//     try {
//       _isConnected = await _checker.hasConnection;
//       log('🟢 [INTERNET] hasConnection check completed: $_isConnected');
//       notifyListeners();

//       _subscription = _checker.onStatusChange.listen((status) {
//         log('🟢 [INTERNET] onStatusChange listener triggered: $status');
//         log('Internet status: $status');

//         _isConnected = status == InternetConnectionStatus.connected;
//         notifyListeners();
//       });
//       log('🟢 [INTERNET] _init() completed - listener attached');
//     } catch (e) {
//       log('🟢 [INTERNET] _init() ERROR: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
// }
