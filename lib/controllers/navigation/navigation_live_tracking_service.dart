import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef NavigationLocationCallback = FutureOr<void> Function(LatLng current);

class NavigationLiveTrackingService {
  StreamSubscription<Position>? _positionStream;

  bool get isTracking => _positionStream != null;

  Future<void> startTracking({
    required NavigationLocationCallback onLocation,
  }) async {
    await stopTracking();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 8,
      ),
    ).listen((position) {
      Future.sync(
        () => onLocation(LatLng(position.latitude, position.longitude)),
      );
    });
  }

  Future<void> stopTracking() async {
    final stream = _positionStream;
    _positionStream = null;
    await stream?.cancel();
  }

  Future<void> dispose() async {
    await stopTracking();
  }
}
