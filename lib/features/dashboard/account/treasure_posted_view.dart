import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/custom_widgets/treasure_posted_card.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';

import '../../../custom_widgets/shimmer_effect.dart';

class TreasurePostedView extends StatefulWidget {
  const TreasurePostedView({super.key});

  @override
  State<TreasurePostedView> createState() => _TreasurePostedViewState();
}

class _TreasurePostedViewState extends State<TreasurePostedView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final positions = await AppPermissions.getCurrentPosition();
      final apis = Provider.of<ApiProvider>(context, listen: false);
      longitude = positions?.longitude.toString();
      latitude = positions?.latitude.toString();
      await apis.getAllTreasuresData(
          1,
          10,
          'mine',
          positions != null ? positions.longitude.toString() : '-73.974187',
          positions != null ? positions.latitude.toString() : '40.771133',
          '10',
          context.read<PreferencesProvider>().accessToken ?? '');
    });
  }

  String? longitude, latitude;
  ValueNotifier<String> availability = ValueNotifier<String>('Available');
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, api, child) => CustomScaffold(
          backgroundColor: AppColors.light,
          child: SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: EasyRefresh.builder(
                onRefresh: () async => await api.getAllTreasuresData(
                    1,
                    10,
                    'mine',
                    longitude ?? '-73.974187',
                    latitude ?? '40.771133',
                    '10',
                    context.read<PreferencesProvider>().accessToken ?? ''),
                childBuilder: (context, physics) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupButton(),
                        Text(
                          AppStrings.treasurePosted,
                          style: AppTextStyles.headingMedium,
                        ),
                        SizedBox.shrink()
                      ],
                    ),
                    ValueListenableBuilder(
                        valueListenable: availability,
                        builder: (context, value, child) {
                          return DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor: AppColors.lightPrimary,
                            value: availability.value,
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
                            onChanged: (value) {
                              availability.value = value!;
                            },
                          );
                        }),
                    api.isLoading
                        ? Expanded(child: ShimmerEffect())
                        : api.getAllTreasureModel?.allTreasuresData == []
                            ? Center(
                                child: Text(
                                  'No treasures posted yet',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              )
                            : Expanded(
                                child: GridView.builder(
                                    physics: physics,
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
                                      return InkWell(
                                        onTap: () {
                                          context.push(Routes.treasureDetails,
                                              extra: thisTreasure);
                                        },
                                        child: TreasurePostedCard(
                                            condition:
                                                thisTreasure?.condition ?? '',
                                            imagePath:
                                                thisTreasure?.photos?.first,
                                            itemName:
                                                thisTreasure?.title ?? ''),
                                      );
                                    }),
                              )
                  ],
                ),
              ))),
    );
  }
}
