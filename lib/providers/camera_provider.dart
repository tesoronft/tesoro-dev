import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraProvider with ChangeNotifier {
  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;
  bool _isLoading = false, _isInitialized = false;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  List<CameraDescription> cameras = [];
  late Future<void> _initializeControllerFuture;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;
  bool _isFlashOn = false;
  bool get isFlashOn => _isFlashOn;

  Future<void> initializeCamera() async {
    _isLoading = true;
    notifyListeners();
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.high,
            enableAudio: false);
        _initializeControllerFuture = _cameraController.initialize();
        _isLoading = false;
        notifyListeners();
      } else {
        log('No cameras available');
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> clickImage() async {
    try {
      final image = await _cameraController.takePicture();
      return image.path;
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return '';
    }
  }

  Future<void> toggleFlash() async {
    try {
      _isFlashOn = !_isFlashOn;
      notifyListeners();
      await _cameraController
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future<void> disposeCamera() async {
    _cameraController.dispose();
    notifyListeners();
  }
}
