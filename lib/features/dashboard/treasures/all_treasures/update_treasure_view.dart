import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/set_image.dart';

import '../../../../consts/app_colors.dart';
import '../../../../consts/app_strings.dart';
import '../../../../consts/app_text_styles.dart';
import '../../../../custom_widgets/custom_btn.dart';
import '../../../../enums/api_enums.dart';
import '../../../../enums/snack_bar_enums.dart';
import '../../../../models/treasures/treasure_post_model.dart';
import '../../../../providers/api_provider.dart';
import '../../../../services/analytics_service.dart';

class UpdateTreasureView extends StatefulWidget {
  UpdateTreasureView({super.key, required this.treasureGetModel});
  final TreasureGetModel treasureGetModel;

  @override
  State<UpdateTreasureView> createState() => _UpdateTreasureViewState();
}

class _UpdateTreasureViewState extends State<UpdateTreasureView> {
  final TreasurePostModel treasurePostModel = TreasurePostModel();

  final PostTreasureController _postTreasureController =
      PostTreasureController();

  ValueNotifier categoryId = ValueNotifier<dynamic>(null);

  ValueNotifier conditionId = ValueNotifier<dynamic>(null);

  @override
  void dispose() {
    _postTreasureController.dispose();
    categoryId.dispose();
    conditionId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _postTreasureController.price.text =
        widget.treasureGetModel.price?.toString() ?? '';
    _postTreasureController.brand.text = widget.treasureGetModel.brand ?? '';
    _postTreasureController.model.text =
        widget.treasureGetModel.itemModel ?? '';
    _postTreasureController.description.text =
        widget.treasureGetModel.description ?? '';
    _postTreasureController.type.text = widget.treasureGetModel.type ?? '';

    _postTreasureController.title.text = widget.treasureGetModel.title ?? '';
    return CustomScaffold(
        backgroundColor: AppColors.light,
        isAppbarRequired: true,
        extendBody: false,
        appBarTitle: 'Edit ${widget.treasureGetModel.title} Info',
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  AppStrings.title,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  hintText: AppStrings.title,
                  keyboardType: TextInputType.name,
                  editingController: _postTreasureController.title,
                ),
                Text(
                  AppStrings.price,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  hintText: AppStrings.estimatePrice,
                  keyboardType: TextInputType.number,
                  editingController: _postTreasureController.price,
                  prefixIcon: Icons.attach_money,
                ),
                Text(
                  AppStrings.category,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                ValueListenableBuilder(
                    valueListenable: categoryId,
                    builder: (context, category, child) {
                      return Consumer<ApiProvider>(
                        builder: (context, apis, child) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color(0xff9EA1A8), width: 0)),
                          padding: EdgeInsets.all(6),
                          child: DropdownButton(
                            underline: Divider(
                              color: Colors.transparent,
                            ),
                            isExpanded: true,
                            hint: Text(
                              'Select Category',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Color(0xff9EA1A8),
                              ),
                            ),
                            dropdownColor: AppColors.light,
                            value: categoryId.value ??
                                widget.treasureGetModel.category?.id,
                            items: List.generate(
                              apis.categoryModelList?.categoryModel?.length ??
                                  0,
                              (index) => DropdownMenuItem(
                                value: apis.categoryModelList
                                    ?.categoryModel?[index].id,
                                child: Text(
                                  apis.categoryModelList?.categoryModel?[index]
                                          .name ??
                                      '',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              categoryId.value = value;
                              log(categoryId.value.toString());
                            },
                          ),
                        ),
                      );
                    }),
                Text(
                  AppStrings.condition,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                ValueListenableBuilder(
                    valueListenable: conditionId,
                    builder: (context, consitions, child) {
                      return Consumer<ApiProvider>(
                        builder: (context, apis, child) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color(
                                    0xff9EA1A8,
                                  ),
                                  width: 0)),
                          padding: EdgeInsets.all(6),
                          child: DropdownButton(
                            underline: Divider(
                              color: Colors.transparent,
                            ),
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            hint: Text(
                              'Select Condition Type',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w100,
                                  color: Color(0xff9EA1A8)),
                            ),
                            value: conditionId.value ??
                                widget.treasureGetModel.condition?.id,
                            dropdownColor: AppColors.light,
                            items: List.generate(
                              apis.conditionsList?.categoryModel?.length ?? 0,
                              (index) => DropdownMenuItem(
                                value: apis
                                    .conditionsList?.categoryModel?[index].id,
                                child: Text(
                                  apis.conditionsList?.categoryModel?[index]
                                          .name ??
                                      '',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(fontWeight: FontWeight.w100),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              conditionId.value = value;
                              log(conditionId.value);
                            },
                          ),
                        ),
                      );
                    }),
                Text(
                  AppStrings.brand,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  hintText: AppStrings.selectBrand,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.brand,
                ),
                Text(
                  AppStrings.model,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  hintText: AppStrings.selectModel,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.model,
                ),
                Text(
                  AppStrings.description,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  hintText: AppStrings.enterItemDesc,
                  maxLength: 10,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.description,
                ),
                Text(
                  'Images',
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.treasureGetModel.photos?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SetImage(
                                imagePath:
                                    widget.treasureGetModel.photos?[index] ??
                                        ''),
                          ),
                          // GestureDetector(
                          //   onTap: () =>
                          //       widget.treasureGetModel.photos?.removeAt(index),
                          //   child: Container(
                          //     margin: const EdgeInsets.all(4),
                          //     decoration: const BoxDecoration(
                          //       color: Color(0xffE4E4E4),
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: const Icon(Icons.close, size: 16),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Consumer2<ApiProvider, PreferencesProvider>(
                  builder: (context, apis, prefs, child) => apis.isLoading
                      ? SpinKitCircle(
                          color: AppColors.primary,
                        )
                      : CustomBtn(
                          text: 'Update',
                          onBtnTap: () async {
                            log(widget.treasureGetModel.productId.toString());

                            treasurePostModel.title =
                                _postTreasureController.title.text;
                            treasurePostModel.brand =
                                _postTreasureController.brand.text;
                            treasurePostModel.description =
                                _postTreasureController.description.text;
                            treasurePostModel.type =
                                _postTreasureController.type.text;
                            treasurePostModel.itemModel =
                                _postTreasureController.model.text;
                            treasurePostModel.condition = conditionId.value ??
                                widget.treasureGetModel.condition?.id;
                            treasurePostModel.category = categoryId.value ??
                                widget.treasureGetModel.category?.id;
                            treasurePostModel.price =
                                int.parse(_postTreasureController.price.text);
                            await AnalyticsService.logEvent(
                                'treasure_info_updated',
                                parameters: {
                                  'treasure_id':
                                      widget.treasureGetModel.productId ?? '',
                                  'treasure_title':
                                      widget.treasureGetModel.title ?? '',
                                });

                            final result = await apis.updateTreasure(
                                prefs.accessToken ?? '',
                                treasurePostModel,
                                widget.treasureGetModel);
                            if (result == ApiEnums.success) {
                              if (context.mounted) {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.success,
                                    apis.responseTxt,
                                    context);
                              }
                            } else {
                              if (context.mounted) {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.failed,
                                    apis.responseTxt,
                                    context);
                              }
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }
}
