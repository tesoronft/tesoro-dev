import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/go_to_camera.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../../../utils/app_permissions.dart';

class PostTreasureView extends StatefulWidget {
  const PostTreasureView({super.key});

  @override
  State<PostTreasureView> createState() => _PostTreasureViewState();
}

class _PostTreasureViewState extends State<PostTreasureView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final positions = await AppPermissions.getCurrentPosition();
      final location = await AppPermissions.getCurrentPlacemark();
      longitude = positions?.longitude;
      latitude = positions?.latitude;

      _postTreasureController.location.text =
          '${location.street} ${location.subLocality}, ${location.locality}, ${location.administrativeArea}, ${location.country}, ${location.postalCode}';
    });
  }

  double? longitude, latitude;
  TreasurePostModel treasurePostModel = TreasurePostModel();
  final PostTreasureController _postTreasureController =
      PostTreasureController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.postYourItem,
      backgroundColor: AppColors.light,
      child: SafeArea(
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
              GoToCamera(onWidgetTap: () {}),
              CustomBtn(
                text: AppStrings.next,
                onBtnTap: () {
                  if (_postTreasureController.location.text.isNotEmpty &&
                      _postTreasureController.title.text.isNotEmpty) {
                    treasurePostModel.location ??= Location();
                    treasurePostModel.location!.coordinates = [
                      longitude ?? 0.0,
                      latitude ?? 0.0,
                    ];
                    treasurePostModel.location!.address =
                        _postTreasureController.location.text;
                    treasurePostModel.title =
                        _postTreasureController.title.text;
                    context.push(Routes.itemDetails, extra: treasurePostModel);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
