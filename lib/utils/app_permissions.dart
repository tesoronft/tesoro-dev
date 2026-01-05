import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissions with ChangeNotifier {
  Placemark? _placemark;
  Placemark? get placemark => _placemark;
  Position? _position;
  Position? get position => _position;
  bool _isCameraPermitted = false;
  bool get isCameraPermitted => _isCameraPermitted;
  Future<Placemark?> getCurrentPlacemark() async {
    LocationPermission permission;

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
    final placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    _placemark = placeMarks[0];
    // log(place.name ?? '');
    // log(place.administrativeArea ?? '');
    // log(place.street ?? '');
    // log(place.country ?? '');
    // log(place.postalCode ?? '');
    // log(place.subLocality ?? '');
    // log(place.locality ?? '');
    notifyListeners();
    return _placemark;

    // return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
  }

  Future<Position?> getCurrentPosition() async {
    LocationPermission permission;

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

    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    notifyListeners();
    log(position!.longitude.toString());
    log(position!.latitude.toString());

    return _position;
  }

  Future<bool> getCameraPermission() async {
    final permission = Permission.camera;
    await permission.request();
    if (await permission.isDenied) {
      await permission.request();
      if (await permission.isDenied) {
        await permission.request();
        if (await permission.isPermanentlyDenied) {
          _isCameraPermitted = false;
          notifyListeners();
          return false;
        } else {
          _isCameraPermitted = true;
          notifyListeners();
          return true;
        }
      } else {
        _isCameraPermitted = true;
        notifyListeners();
        return true;
      }
    } else {
      _isCameraPermitted = true;
      notifyListeners();
      return true;
    }
  }
}
