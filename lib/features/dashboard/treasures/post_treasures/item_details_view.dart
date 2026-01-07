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
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

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
      final apis = Provider.of<ApiProvider>(context, listen: false);
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      await apis.getCategories(prefs.accessToken ?? '');
    });
  }

  final PostTreasureController _postTreasureController =
      PostTreasureController();
  ValueNotifier categoryId = ValueNotifier<dynamic>(null);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.itemDetails,
      backgroundColor: AppColors.light,
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
            valueListenable: categoryId,
            builder: (context, id, child) {
              return SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        AppStrings.price,
                        style: AppTextStyles.bodySmall,
                      ),
                      CustomTextField(
                        hintText: AppStrings.price,
                        keyboardType: TextInputType.text,
                        editingController: _postTreasureController.price,
                      ),
                      Text(
                        AppStrings.category,
                        style: AppTextStyles.bodySmall,
                      ),
                      Consumer<ApiProvider>(
                        builder: (context, apis, child) => DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Select Category',
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                          value: categoryId.value,
                          items: List.generate(
                            apis.categoryModelList?.categoryModel?.length ?? 0,
                            (index) => DropdownMenuItem(
                              value: apis
                                  .categoryModelList?.categoryModel?[index].id,
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
                          },
                        ),
                      ),
                      // CustomTextField(
                      //   hintText: AppStrings.selectCategory,
                      //   keyboardType: TextInputType.text,
                      //   editingController: _postTreasureController.category,
                      // ),
                      Text(
                        AppStrings.condition,
                        style: AppTextStyles.bodySmall,
                      ),
                      CustomTextField(
                        hintText: AppStrings.selectCondition,
                        keyboardType: TextInputType.text,
                        editingController: _postTreasureController.condition,
                      ),
                      Text(
                        AppStrings.brand,
                        style: AppTextStyles.bodySmall,
                      ),
                      CustomTextField(
                        hintText: AppStrings.selectBrand,
                        keyboardType: TextInputType.text,
                        editingController: _postTreasureController.brand,
                      ),
                      Text(
                        AppStrings.model,
                        style: AppTextStyles.bodySmall,
                      ),
                      CustomTextField(
                        hintText: AppStrings.selectModel,
                        keyboardType: TextInputType.text,
                        editingController: _postTreasureController.model,
                      ),
                      Text(
                        AppStrings.type,
                        style: AppTextStyles.bodySmall,
                      ),
                      CustomTextField(
                        hintText: AppStrings.selectType,
                        keyboardType: TextInputType.text,
                        editingController: _postTreasureController.type,
                      ),
                      Text(
                        AppStrings.description,
                        style: AppTextStyles.bodySmall,
                      ),
                      CustomTextField(
                        hintText: AppStrings.enterItemDesc,
                        keyboardType: TextInputType.text,
                        editingController: _postTreasureController.description,
                      ),
                      CustomBtn(
                        text: AppStrings.next,
                        onBtnTap: () {
                          widget.treasurePostModel.brand =
                              _postTreasureController.brand.text;
                          widget.treasurePostModel.description =
                              _postTreasureController.description.text;
                          widget.treasurePostModel.type =
                              _postTreasureController.type.text;
                          widget.treasurePostModel.itemModel =
                              _postTreasureController.model.text;
                          widget.treasurePostModel.condition =
                              _postTreasureController.condition.text;
                          widget.treasurePostModel.category = categoryId.value;
                          widget.treasurePostModel.price =
                              int.parse(_postTreasureController.price.text);
                          context.push(Routes.confirmDetails,
                              extra: widget.treasurePostModel);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
