import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class DeviceImagePicker {
  final ImagePicker imagePicker = ImagePicker();
  Future<List<XFile>?> pickImage() async {
    try {
      final result = await imagePicker.pickMultiImage();
      log(result.first.path);
      log(result.last.path);
      return result;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
