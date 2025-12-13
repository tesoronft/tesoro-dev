import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/custom_widgets/shimmer_effect.dart';

import '../../../../consts/app_colors.dart';
import '../../../../consts/app_strings.dart';
import '../../../../consts/app_text_styles.dart';
import '../../../../custom_widgets/custom_scaffold.dart';
import '../../../../custom_widgets/popup_button.dart';
import '../../../../custom_widgets/treasure_posted_card.dart';
import '../../../../providers/api_provider.dart';
import '../../../../providers/preferences_provider.dart';

class AllTreasuresView extends StatefulWidget {
  const AllTreasuresView({super.key});

  @override
  State<AllTreasuresView> createState() => _AllTreasuresViewState();
}

class _AllTreasuresViewState extends State<AllTreasuresView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (apis.getAllTreasureModel == null) {
        await apis.getAllTreasuresData(1, 10, 'all', '67.0011', '24.8607', '10',
            context.read<PreferencesProvider>().accessToken ?? '');
      }
    });
  }

  ValueNotifier<int> rangeNotifier = ValueNotifier<int>(10);
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, api, child) => CustomScaffold(
          backgroundColor: AppColors.light,
          child: SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: api.isLoading
                  ? Center(child: ShimmerEffect())
                  : api.getAllTreasureModel?.allTreasuresData == []
                      ? Center(
                          child: Text(
                            'No treasures posted yet',
                            style: AppTextStyles.bodyMedium,
                          ),
                        )
                      : ValueListenableBuilder(
                          valueListenable: rangeNotifier,
                          builder: (context, range, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    PopupButton(),
                                    Text(
                                      AppStrings.treasurePosted,
                                      style: AppTextStyles.headingMedium,
                                    ),
                                    SizedBox.shrink()
                                  ],
                                ),
                                Center(
                                  child: DropdownButton(
                                    borderRadius: BorderRadius.circular(10),
                                    value: AppStrings.available,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Available',
                                        child: Text(
                                          AppStrings.available,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ),
                                      DropdownMenuItem(
                                          value: 'Unavailable',
                                          child: Text(
                                            AppStrings.unavailable,
                                            style: AppTextStyles.bodyMedium,
                                          ))
                                    ],
                                    onChanged: (value) {},
                                  ),
                                ),
                                Text(
                                  '${AppStrings.distance}: $range Miles',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Slider(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  value: rangeNotifier.value.toDouble(),
                                  thumbColor: AppColors.primary,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) async {
                                    rangeNotifier.value = value.toInt();
                                  },
                                  onChangeEnd: (value) async {
                                    await api.getAllTreasuresData(
                                      1,
                                      10,
                                      'all',
                                      '67.0011',
                                      '24.8607',
                                      value.toInt().toString(),
                                      context
                                              .read<PreferencesProvider>()
                                              .accessToken ??
                                          '',
                                    );
                                  },
                                ),
                                Expanded(
                                    child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                childAspectRatio: 0.9,
                                                mainAxisSpacing: 10),
                                        itemCount: api.getAllTreasureModel
                                            ?.allTreasuresData?.length,
                                        itemBuilder: (context, index) {
                                          final thisTreasure = api
                                              .getAllTreasureModel
                                              ?.allTreasuresData?[index];
                                          return TreasurePostedCard(
                                              condition:
                                                  thisTreasure?.condition ?? '',
                                              imagePath:
                                                  thisTreasure?.photos?.first,
                                              itemName:
                                                  thisTreasure?.title ?? '');
                                        }))
                              ],
                            );
                          }))),
    );
  }
}
