import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';

class CameraComponents extends StatelessWidget {
  const CameraComponents(
      {super.key,
      required this.onCameraClickTap,
      required this.onFlashTap,
      required this.onGalleryTap});
  final VoidCallback onGalleryTap, onCameraClickTap, onFlashTap;
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
            AppImages.flash,
            height: 60,
          ),
        ),
      ],
    );
  }
}
