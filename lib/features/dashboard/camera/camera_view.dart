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

import '../../../services/analytics_service.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      final permissions = context.read<AppPermissions>();
      final camera = context.read<CameraProvider>();

      await permissions.getCameraPermission();

      await camera.initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //context.read<CameraProvider>().disposeCamera();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (!mounted) return;

  //   final camera = context.read<CameraProvider>();

  //   if (state == AppLifecycleState.resumed) {
  //     log('App resumed – checking camera permission');

  //     final isGranted =
  //         await context.read<AppPermissions>().checkCameraPermission();

  //     if (isGranted && !camera.isInitialized) {
  //       await camera.initializeCamera();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      child: Consumer2<PreferencesProvider, CameraProvider>(
        builder: (context, prefs, camera, child) => Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            camera.cameraController == null || !camera.isInitialized
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
                      await AnalyticsService.logEvent('camera_closed');
                      await camera.disposeCamera();
                      context.pop();
                    },
                  ),
                  CameraComponents(
                    onGalleryTap: () async {
                      await AnalyticsService.logEvent(
                          'user_picked_image_from_gallery');
                      final result = await DeviceImagePicker().pickImage();
                      camera.setImages(
                        result?.map((path) => path.path).toList() ?? [],
                      );
                      await camera.disposeCamera();
                      context.pop();
                    },
                    onCameraClickTap: () async {
                      await AnalyticsService.logEvent(
                          'user_clicked_image_from_camera');
                      await camera.clickImage();
                      await camera.disposeCamera();
                      context.pop();
                    },
                    onFlashTap: () async {
                      await AnalyticsService.logEvent('user_toggled_flash');
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
