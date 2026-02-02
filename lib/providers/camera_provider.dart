import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class CameraProvider with ChangeNotifier {
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  bool _isLoading = false;
  bool get isInitialized => cameraController?.value.isInitialized ?? false;
  bool get isLoading => _isLoading;

  List<CameraDescription> cameras = [];
  List<String> get cameraImages => _cameraImages;
  List<String> _cameraImages = [];
  Future<void>? _initializeControllerFuture;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;
  bool _isFlashOn = false;
  bool get isFlashOn => _isFlashOn;
  void setImages(List<String> images) {
    _cameraImages.addAll(images);
    notifyListeners();
  }

  void removeImage(int index) {
    _cameraImages.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeCamera() async {
    _isLoading = true;
    notifyListeners();
    try {
      cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.high,
            enableAudio: false);

        await _cameraController?.initialize();
        log('Camera initialized');
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
      final image = await _cameraController?.takePicture();
      log(image?.path ?? '');
      _cameraImages.add(image?.path ?? '');
      return image?.path ?? '';
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
          ?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future<void> disposeCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    notifyListeners();
  }
}
