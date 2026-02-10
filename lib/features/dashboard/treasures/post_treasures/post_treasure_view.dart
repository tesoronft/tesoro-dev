import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/treasure_properties.dart';
import 'package:tesoro_nft_app/custom_widgets/go_to_camera.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/custom_widgets/permission_enable_component.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/providers/camera_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../../../providers/api_provider.dart';
import '../../../../providers/preferences_provider.dart';
import '../../../../services/analytics_service.dart';
import '../../../../utils/app_permissions.dart';

class PostTreasureView extends StatefulWidget {
  const PostTreasureView({super.key});

  @override
  State<PostTreasureView> createState() => _PostTreasureViewState();
}

class _PostTreasureViewState extends State<PostTreasureView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      final geoLocation = Provider.of<AppPermissions>(context, listen: false);
      final apis = Provider.of<ApiProvider>(context, listen: false);
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      await apis.getCategories(prefs.accessToken ?? '');
      await apis.getConditions(prefs.accessToken ?? '');
      await geoLocation.getCurrentPosition();
      await geoLocation.getCurrentPlacemark();
      // await geoLocation.checkLocationPermission();

      _postTreasureController.location.text =
          '${geoLocation.placemark?.street} ${geoLocation.placemark?.subLocality}, ${geoLocation.placemark?.locality}, ${geoLocation.placemark?.administrativeArea}, ${geoLocation.placemark?.country}, ${geoLocation.placemark?.postalCode}';
    });
  }

  double? longitude, latitude;
  TreasurePostModel treasurePostModel = TreasurePostModel();
  final PostTreasureController _postTreasureController =
      PostTreasureController();
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.postYourItem,
      backgroundColor: AppColors.light,
      child: Stack(
        children: [
          SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.title,
                    style: AppTextStyles.bodySmall,
                  ),
                  CustomTextField(
                    hintText: AppStrings.enterTitle,
                    keyboardType: TextInputType.text,
                    fillColors: Colors.grey[100],
                    editingController: _postTreasureController.title,
                  ),
                  Text(
                    AppStrings.location,
                    style: AppTextStyles.bodySmall,
                  ),
                  CustomTextField(
                    hintText: AppStrings.addLocation,
                    keyboardType: TextInputType.text,
                    fillColors: Colors.grey[100],
                    editingController: _postTreasureController.location,
                  ),
                  Text(
                    AppStrings.addPhotos,
                    style: AppTextStyles.bodySmall,
                  ),
                  Consumer<CameraProvider>(
                    builder: (context, camera, child) => Row(
                      spacing: 10,
                      children: [
                        if (camera.cameraImages.isNotEmpty)
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: camera.cameraImages.length,
                                itemBuilder: (context, index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.file(
                                          File(camera.cameraImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      GestureDetector(
                                        // InkWell works too, but GestureDetector is lighter for simple icons
                                        onTap: () => camera.removeImage(index),
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Color(0xffE4E4E4),
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                              const Icon(Icons.close, size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: GoToCamera(onWidgetTap: () async {
                            await AnalyticsService.logEvent(
                                'treasure_properties_dialog');
                            final result = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => TreasureProperties(),
                            );
                            if (result == true) {
                              await AnalyticsService.logEvent(
                                  'go_to_camera_view');
                              context.push(Routes.cameraView);
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  Consumer<AppPermissions>(
                    builder: (context, permission, child) => CustomBtn(
                      text: AppStrings.next,
                      onBtnTap: () async {
                        if (_postTreasureController.location.text.isNotEmpty &&
                            _postTreasureController.title.text.isNotEmpty) {
                          treasurePostModel.location ??= Location();
                          treasurePostModel.photos ??= [];

                          treasurePostModel.location?.coordinates = [
                            permission.position?.longitude ?? 0.0,
                            permission.position?.latitude ?? 0.0,
                          ];

                          treasurePostModel.location!.address =
                              _postTreasureController.location.text;
                          treasurePostModel.title =
                              _postTreasureController.title.text;
                          treasurePostModel.photos!.addAll(
                              context.read<CameraProvider>().cameraImages);
                          log(longitude.toString());
                          log(latitude.toString());
                          if (permission.position != null) {
                            context.push(Routes.itemDetails,
                                extra: treasurePostModel);
                          } else {
                            CustomSnackbar().showSnackbar(
                              SnackBarEnums.failed,
                              'Unable to get your location. Please try again.',
                              context,
                            );
                          }

                          // if (permission.permissionState ==
                          //     PermissionState.granted) {

                          // } else if (permission.permissionState ==
                          //     PermissionState.deniedForever) {
                          //   CustomSnackbar().showSnackbar(
                          //     SnackBarEnums.processing,
                          //     'Please enable location permission from settings',
                          //     context,
                          //   );
                          //   await permission.openLocationSettings();
                          // } else {
                          //   CustomSnackbar().showSnackbar(
                          //     SnackBarEnums.processing,
                          //     'Please allow us to access your location',
                          //     context,
                          //   );
                          // }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ApiProvider>(
            builder: (context, apis, child) => apis.isLoading
                ? Align(alignment: Alignment.center, child: LoaderWidget())
                : SizedBox.shrink(),
          ),
          Consumer<AppPermissions>(
            builder: (context, permissions, child) =>
                !permissions.isLocationAllowed
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: PermissionEnableComponent())
                    : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
