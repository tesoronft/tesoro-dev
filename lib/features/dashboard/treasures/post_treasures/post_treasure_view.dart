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
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/go_to_camera.dart';
import 'package:tesoro_nft_app/custom_widgets/permission_enable_component.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/providers/camera_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final geoLocation = Provider.of<AppPermissions>(context, listen: false);
      await geoLocation.getCurrentPosition();
      geoLocation.getCurrentPlacemark();

      _postTreasureController.location.text =
          '${geoLocation.placemark?.street} ${geoLocation.placemark?.subLocality}, ${geoLocation.placemark?.locality}, ${geoLocation.placemark?.administrativeArea}, ${geoLocation.placemark?.country}, ${geoLocation.placemark?.postalCode}';

      // _postTreasureController.location.text = 'Samanabad, Lahore, Pakistan';
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      log("App Resumed: Re-checking location permissions...");
      final geoLocation = Provider.of<AppPermissions>(context);
      await geoLocation.getCurrentPosition();
      geoLocation.getCurrentPlacemark();

      _postTreasureController.location.text =
          '${geoLocation.placemark?.street} ${geoLocation.placemark?.subLocality}, ${geoLocation.placemark?.locality}, ${geoLocation.placemark?.administrativeArea}, ${geoLocation.placemark?.country}, ${geoLocation.placemark?.postalCode}';

      //_postTreasureController.location.text = 'Samanabad, Lahore, Pakistan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.postYourItem,
      backgroundColor: AppColors.light,
      child: Stack(
        alignment: Alignment.bottomCenter,
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
                          child: GoToCamera(onWidgetTap: () {
                            context.push(Routes.cameraView);
                          }),
                        ),
                      ],
                    ),
                  ),
                  CustomBtn(
                    text: AppStrings.next,
                    // isDisabled: _postTreasureController.location.text.isEmpty ||
                    //     _postTreasureController.title.text.isEmpty,
                    onBtnTap: () {
                      if (_postTreasureController.location.text.isNotEmpty &&
                          _postTreasureController.title.text.isNotEmpty) {
                        treasurePostModel.location ??= Location();
                        treasurePostModel.photos ??= [];

                        treasurePostModel.location!.coordinates = [
                          longitude ?? 0.0,
                          latitude ?? 0.0,
                          // 74.2985,
                          // 31.5357,
                        ];

                        treasurePostModel.location!.address =
                            _postTreasureController.location.text;
                        treasurePostModel.title =
                            _postTreasureController.title.text;
                        treasurePostModel.photos!.addAll(
                            context.read<CameraProvider>().cameraImages);
                        context.push(Routes.itemDetails,
                            extra: treasurePostModel);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Consumer<AppPermissions>(
              builder: (context, permission, child) =>
                  permission.placemark == null || permission.position == null
                      ? PermissionEnableComponent()
                      : SizedBox.shrink())
        ],
      ),
    );
  }
}
