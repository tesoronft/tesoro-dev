import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AppPermissions {
  static Future<Placemark> getCurrentPlacemark() async {
    bool locationEnables;
    LocationPermission permission;

    locationEnables = await Geolocator.isLocationServiceEnabled();

    if (!locationEnables) {
      await Geolocator.openLocationSettings();
      log('User device location is off');
      return Future.error('User device location is off');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied forever');
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placeMark[0];
    return place;

    // return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
  }

  static Future<Position?> getCurrentPosition() async {
    bool locationEnables;
    LocationPermission permission;

    locationEnables = await Geolocator.isLocationServiceEnabled();

    if (!locationEnables) {
      await Geolocator.openLocationSettings();
      log('User device location is off');
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are denied forever');
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log(position.latitude.toString());
    log(position.latitude.toString());
    return position;
  }
}
