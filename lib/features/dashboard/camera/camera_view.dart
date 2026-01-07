import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/custom_widgets/camera/camera_components.dart';
import 'package:tesoro_nft_app/custom_widgets/camera/camera_unavailable_view.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/providers/camera_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';
import 'package:tesoro_nft_app/utils/device_image_picker.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final camera = Provider.of<CameraProvider>(context, listen: false);
      final permissions = Provider.of<AppPermissions>(context, listen: false);
      final result = await permissions.getCameraPermission();

      if (result == true) {
        await camera.initializeCamera();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      child: Consumer2<PreferencesProvider, CameraProvider>(
        builder: (context, prefs, camera, child) => Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            camera.cameraController == null ||
                    !camera.cameraController!.value.isInitialized
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CameraUnavailableView(),
                  )
                : camera.isLoading
                    ? Center(child: LoaderWidget())
                    : CameraPreview(camera.cameraController!),
            SafeArea(
              minimum: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupButton(
                    onTap: () async {
                      await camera.disposeCamera();
                      context.pop();
                    },
                  ),
                  CameraComponents(
                    onGalleryTap: () async {
                      final result = await DeviceImagePicker().pickImage();
                      camera.setImages(
                        result?.map((path) => path.path).toList() ?? [],
                      );
                      await camera.disposeCamera();
                      context.pop();
                    },
                    onCameraClickTap: () async {
                      await camera.clickImage();
                      await camera.disposeCamera();
                      context.pop();
                    },
                    onFlashTap: () async {
                      camera.toggleFlash();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
