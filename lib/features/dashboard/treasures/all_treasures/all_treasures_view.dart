import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/custom_widgets/home_center_arrow.dart';
import 'package:tesoro_nft_app/custom_widgets/shimmer_effect.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/empty_view.dart';
import 'package:tesoro_nft_app/features/others/offline_view.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/internet_checker.dart';

import '../../../../consts/app_colors.dart';
import '../../../../consts/app_strings.dart';
import '../../../../consts/app_text_styles.dart';
import '../../../../custom_widgets/custom_scaffold.dart';
import '../../../../custom_widgets/permission_enable_component.dart';
import '../../../../custom_widgets/treasure_posted_card.dart';

import '../../../../models/treasures/get_all_treasures_model.dart';
import '../../../../providers/api_provider.dart';
import '../../../../providers/preferences_provider.dart';
import '../../../../utils/app_permissions.dart';

class AllTreasuresView extends StatefulWidget {
  const AllTreasuresView({super.key, required this.isFromHome});
  final bool isFromHome;
  @override
  State<AllTreasuresView> createState() => _AllTreasuresViewState();
}

class _AllTreasuresViewState extends State<AllTreasuresView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final permissions = context.read<AppPermissions>();
      final api = context.read<ApiProvider>();

      final position = await permissions.getCurrentPosition();

      await api.getAllTreasuresData(
        1,
        6,
        'all',
        position?.longitude.toString() ?? '0.0',
        position?.latitude.toString() ?? '0.0',
        '10',
        context.read<PreferencesProvider>().accessToken ?? '',
      );
      getAllTreasureModel = api.getAllTreasureModel;
    });
  }

  GetAllTreasuresModel? getAllTreasureModel;
  ValueNotifier<int> rangeNotifier = ValueNotifier<int>(10);
  @override
  Widget build(BuildContext context) {
    return Consumer3<ApiProvider, AppPermissions, InternetChecker>(
      builder: (context, api, permissions, internet, child) => CustomScaffold(
          backgroundColor: AppColors.light,
          isAppbarRequired: true,
          appBarTitle: AppStrings.allTreasures,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: EasyRefresh.builder(onRefresh: () async {
                  await api.getAllTreasuresData(
                      1,
                      6,
                      'all',
                      permissions.position?.longitude.toString() ?? '0.0',
                      permissions.position?.latitude.toString() ?? '0.0',
                      '10',
                      context.read<PreferencesProvider>().accessToken ?? '');
                  getAllTreasureModel = api.getAllTreasureModel;
                }, onLoad: () async {
                  final currentPage =
                      api.getAllTreasureModel?.pagination?.page ?? 1;
                  final totalPages = api
                          .getAllTreasureModel?.pagination?.totalPages
                          ?.toInt() ??
                      1;
                  if (currentPage < totalPages) {
                    await api.getAllTreasuresData(
                        currentPage + 1,
                        4,
                        'all',
                        permissions.position?.longitude.toString() ?? '0.0',
                        permissions.position?.latitude.toString() ?? '0.0',
                        '10',
                        context.read<PreferencesProvider>().accessToken ?? '');
                    getAllTreasureModel?.allTreasuresData?.addAll(
                        api.getAllTreasureModel?.allTreasuresData ?? []);
                  }
                }, childBuilder: (context, physics) {
                  if (api.isLoading) {
                    return ShimmerEffect();
                  }

                  if (getAllTreasureModel?.allTreasuresData == null) {
                    return SizedBox();
                  }

                  if (getAllTreasureModel?.allTreasuresData?.isEmpty ?? true) {
                    return EmptyView();
                  }
                  if (internet.isConnected == false) {
                    return OfflineView();
                  }
                  return ValueListenableBuilder(
                      valueListenable: rangeNotifier,
                      builder: (context, range, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  5,
                                  'all',
                                  permissions.position?.longitude.toString() ??
                                      '0.0',
                                  permissions.position?.latitude.toString() ??
                                      '0.0',
                                  value.toInt().toString(),
                                  context
                                          .read<PreferencesProvider>()
                                          .accessToken ??
                                      '',
                                );
                                getAllTreasureModel = api.getAllTreasureModel;
                              },
                            ),
                            Expanded(
                              child: GridView.builder(
                                  physics: physics,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 0.9,
                                          mainAxisSpacing: 10),
                                  itemCount: getAllTreasureModel
                                      ?.allTreasuresData?.length,
                                  itemBuilder: (context, index) {
                                    final thisTreasure = getAllTreasureModel
                                        ?.allTreasuresData?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        log('Navigating to details of treasure id: ${thisTreasure?.postedBy?.rating}');
                                        context.push(Routes.treasureDetails,
                                            extra: thisTreasure);
                                      },
                                      child: TreasurePostedCard(
                                          collectedBy:
                                              thisTreasure?.collectedBy?.name ??
                                                  'Not Collected',
                                          condition:
                                              thisTreasure?.condition?.name ??
                                                  '',
                                          imagePath:
                                              thisTreasure?.photos?.first,
                                          itemName: thisTreasure?.title ?? ''),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      });
                }),
              ),
              if (widget.isFromHome)
                Align(
                    alignment: Alignment.centerLeft,
                    child: HomeCenterArrow(isForHome: false)),
              !permissions.isLocationAllowed
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: PermissionEnableComponent(
                        txt:
                            'For accurate data, we require location permission',
                      ))
                  : SizedBox.shrink()
            ],
          )),
    );
  }
}
