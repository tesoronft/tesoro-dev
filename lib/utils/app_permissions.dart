import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../enums/permission_state_enums.dart';

class AppPermissions with ChangeNotifier {
  Placemark? _placemark;
  Placemark? get placemark => _placemark;
  Position? _position;
  Position? get position => _position;
  bool _isCameraPermitted = false;
  bool get isCameraPermitted => _isCameraPermitted;
  PermissionState permissionState = PermissionState.denied;
  bool isInitialized = false;
  bool _isLocationAllowed = false;
  bool get isLocationAllowed => _isLocationAllowed;

  AppPermissions() {
    log('🟣 [PERMS] AppPermissions constructor called');
  }

  @override
  void dispose() {
    log('🟣 [PERMS] AppPermissions dispose() called');
    _placemark = null;
    _position = null;
    super.dispose();
  }

  Future<Placemark?> getCurrentPlacemark() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        _isLocationAllowed = false;

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _isLocationAllowed = false;

      return Future.error('Location permissions are denied forever');
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _isLocationAllowed = true;
    } else {
      _isLocationAllowed = false;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    _placemark = placeMarks[0];

    notifyListeners();
    return _placemark;
  }

  Future<PermissionState> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _isLocationAllowed = false;
      notifyListeners();
      return PermissionState.deniedForever;
    }

    if (permission == LocationPermission.denied) {
      _isLocationAllowed = false;
      notifyListeners();
      return PermissionState.denied;
    }

    _isLocationAllowed = true;
    notifyListeners();
    return PermissionState.granted;
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<PermissionState> checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      _isLocationAllowed = false;
      permissionState = PermissionState.deniedForever;

      notifyListeners();
      return PermissionState.deniedForever;
    }

    if (permission == LocationPermission.denied) {
      _isLocationAllowed = false;
      permissionState = PermissionState.denied;
      notifyListeners();
      return PermissionState.denied;
    }

    _isLocationAllowed = true;
    permissionState = PermissionState.granted;
    notifyListeners();
    return PermissionState.granted;
  }

  Future<Position?> getCurrentPosition() async {
    log('🟣 [PERMS] getCurrentPosition() called');
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      log('🟣 [PERMS] location permission checked: $permission');

      if (permission == LocationPermission.denied) {
        log('🟣 [PERMS] requesting location permission');
        permission = await Geolocator.requestPermission();
        log('🟣 [PERMS] permission result: $permission');
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log('🟣 [PERMS] location permission denied/denied forever');
        _isLocationAllowed = false;
        notifyListeners();
        return null;
      }

      log('🟣 [PERMS] location permission granted, getting position');
      _isLocationAllowed = true;
      notifyListeners();

      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      log('🟣 [PERMS] getCurrentPosition() completed: ${_position?.latitude}, ${_position?.longitude}');

      return _position;
    } catch (e) {
      log('🟣 [PERMS] getCurrentPosition() ERROR: $e');
      rethrow;
    }
  }

  Future<bool> checkCameraPermission() async {
    await Permission.camera.request();
    final status = await Permission.camera.status;

    if (status.isGranted) {
      _isCameraPermitted = true;
      notifyListeners();
      return true;
    }

    if (status.isPermanentlyDenied) {
      _isCameraPermitted = false;
      notifyListeners();
      return false;
    }

    _isCameraPermitted = false;
    notifyListeners();
    return false;
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
