import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';

class CameraComponents extends StatelessWidget {
  const CameraComponents(
      {super.key,
      required this.onCameraClickTap,
      this.isFlashOn = false,
      required this.onFlashTap,
      required this.onGalleryTap});
  final VoidCallback onGalleryTap, onCameraClickTap, onFlashTap;
  final bool isFlashOn;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: onGalleryTap,
          child: Image.asset(
            AppImages.gallery,
            height: 60,
          ),
        ),
        InkWell(
          onTap: onCameraClickTap,
          child: Image.asset(
            AppImages.cameraClick,
            height: 80,
          ),
        ),
        InkWell(
          onTap: onFlashTap,
          child: Image.asset(
            isFlashOn ? AppImages.flash : AppImages.flashOff,
            height: 60,
          ),
        ),
      ],
    );
  }
}
