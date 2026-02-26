import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/services/analytics_service.dart';

import '../../../../utils/form_validator.dart';

class ItemDetailsView extends StatefulWidget {
  const ItemDetailsView({super.key, required this.treasurePostModel});
  final TreasurePostModel treasurePostModel;

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AnalyticsService.logEvent('item_details_view');
    });
  }

  final PostTreasureController _postTreasureController =
      PostTreasureController();
  ValueNotifier categoryId = ValueNotifier<dynamic>(null);
  ValueNotifier conditionId = ValueNotifier<dynamic>(null);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBody: false,
      isAppbarRequired: true,
      resizeToBottomAllowed: true,
      appBarTitle: AppStrings.itemDetails,
      backgroundColor: AppColors.light,
      child: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  AppStrings.price,
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  hintText: AppStrings.estimatePrice,
                  keyboardType: TextInputType.number,
                  editingController: _postTreasureController.price,
                  validation: FormValidators.validatePrice(
                      _postTreasureController.price.text),
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
                        builder: (context, apis, child) => apis.isLoading
                            ? SpinKitCircle(
                                color: AppColors.primary,
                              )
                            : Container(
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
                                  value: categoryId.value,
                                  items: List.generate(
                                    apis.categoryModelList?.categoryModel
                                            ?.length ??
                                        0,
                                    (index) => DropdownMenuItem(
                                      value: apis.categoryModelList
                                          ?.categoryModel?[index].id,
                                      child: Text(
                                        apis.categoryModelList
                                                ?.categoryModel?[index].name ??
                                            '',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    categoryId.value = value;
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
                        builder: (context, apis, child) => apis.isLoading
                            ? SpinKitCircle(
                                color: AppColors.primary,
                              )
                            : Container(
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
                                  value: conditionId.value,
                                  dropdownColor: AppColors.light,
                                  items: List.generate(
                                    apis.conditionsList?.categoryModel
                                            ?.length ??
                                        0,
                                    (index) => DropdownMenuItem(
                                      value: apis.conditionsList
                                          ?.categoryModel?[index].id,
                                      child: Text(
                                        apis.conditionsList
                                                ?.categoryModel?[index].name ??
                                            '',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                                fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    conditionId.value = value;
                                  },
                                ),
                              ),
                      );
                    }),
                Text(
                  AppStrings.brand,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectBrand,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.brand,
                  validation: FormValidators.validateTreasureBrand(
                      _postTreasureController.brand.text),
                ),
                Text(
                  AppStrings.model,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectModel,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.model,
                  validation: FormValidators.validateTreasureModel(
                      _postTreasureController.model.text),
                ),
                Text(
                  AppStrings.description,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.enterItemDesc,
                  maxLength: 10,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.description,
                ),
                Consumer<ApiProvider>(
                  builder: (context, apis, child) => CustomBtn(
                    text: AppStrings.next,
                    onBtnTap: () async {
                      if (!_formKey.currentState!.validate() ||
                          categoryId.value == null ||
                          conditionId.value == null) {
                        return;
                      }
                      widget.treasurePostModel.categoryId = apis
                          .categoryModelList?.categoryModel
                          ?.firstWhere(
                              (element) => element.id == categoryId.value)
                          .name;
                      widget.treasurePostModel.conditionId = apis
                          .conditionsList?.categoryModel
                          ?.firstWhere(
                              (element) => element.id == conditionId.value)
                          .name;
                      widget.treasurePostModel.brand =
                          _postTreasureController.brand.text;
                      widget.treasurePostModel.description =
                          _postTreasureController.description.text;
                      widget.treasurePostModel.type =
                          _postTreasureController.type.text;
                      widget.treasurePostModel.itemModel =
                          _postTreasureController.model.text;
                      widget.treasurePostModel.condition = conditionId.value;
                      widget.treasurePostModel.category = categoryId.value;
                      widget.treasurePostModel.price =
                          int.parse(_postTreasureController.price.text);
                      await AnalyticsService.logEvent('confirm_details_view');
                      context.push(Routes.confirmDetails,
                          extra: widget.treasurePostModel);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
