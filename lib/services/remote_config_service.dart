import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;
  static Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    log('Remote congif initialized');
    await _remoteConfig.fetchAndActivate();
  }

  static String getString(String key) {
    log('Fetching Remote Config for key: $key, Value: ${_remoteConfig.getString(key)}');
    return _remoteConfig.getString(key);
  }

  static bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  static int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  static double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }
}
