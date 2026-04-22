import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/treasure_posted_card.dart';
import 'package:tesoro_nft_app/features/others/offline_view.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';
import 'package:tesoro_nft_app/utils/internet_checker.dart';

import '../../../custom_widgets/permission_enable_component.dart';
import '../../../custom_widgets/shimmer_effect.dart';
import '../../../custom_widgets/treasures/empty_view.dart';
import '../../../models/treasures/get_all_treasures_model.dart';

class TreasurePostedView extends StatefulWidget {
  const TreasurePostedView({super.key});

  @override
  State<TreasurePostedView> createState() => _TreasurePostedViewState();
}

class _TreasurePostedViewState extends State<TreasurePostedView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final positions =
          await Provider.of<AppPermissions>(context, listen: false)
              .getCurrentPosition();

      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (apis.categoryModelList?.categoryModel?.isEmpty ?? true) {
        await apis.getCategories(
            context.read<PreferencesProvider>().accessToken ?? '');
        await apis.getConditions(
            context.read<PreferencesProvider>().accessToken ?? '');
      }
      await apis.getAllTreasuresData(
          1,
          10,
          'mine',
          positions != null ? positions.longitude.toString() : '0.0',
          positions != null ? positions.latitude.toString() : '0.0',
          '10',
          context.read<PreferencesProvider>().accessToken ?? '');
      getAllTreasureModel = apis.getAllTreasureModel;
    });
  }

  GetAllTreasuresModel? getAllTreasureModel;
  ValueNotifier<String> availability = ValueNotifier<String>('Available');

  @override
  void dispose() {
    availability.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, AppPermissions>(
      builder: (context, api, permissions, child) => CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: AppStrings.myTreasures,
          backgroundColor: AppColors.light,
          child: SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: EasyRefresh.builder(
                onRefresh: () async {
                  await api.getAllTreasuresData(
                      1,
                      5,
                      'mine',
                      permissions.position?.longitude.toString() ?? '0.0',
                      permissions.position?.latitude.toString() ?? '0.0',
                      '10',
                      context.read<PreferencesProvider>().accessToken ?? '');
                  getAllTreasureModel = api.getAllTreasureModel;
                },
                onLoad: () async {
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
                        'mine',
                        permissions.position?.longitude.toString() ?? '0.0',
                        permissions.position?.latitude.toString() ?? '0.0',
                        '10',
                        context.read<PreferencesProvider>().accessToken ?? '');
                    getAllTreasureModel?.allTreasuresData?.addAll(
                        api.getAllTreasureModel?.allTreasuresData ?? []);
                  }
                },
                childBuilder: (context, physics) {
                  if (api.isLoading) {
                    return ShimmerEffect();
                  }

                  if (getAllTreasureModel?.allTreasuresData == null) {
                    return SizedBox();
                  }

                  if (getAllTreasureModel?.allTreasuresData?.isEmpty ?? true) {
                    return EmptyView();
                  }
                  // if (internet.isConnected == false) {
                  //   return OfflineView();
                  // }
                  if (!permissions.isLocationAllowed) {
                    return PermissionEnableComponent();
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                            physics: physics,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.9,
                                    mainAxisSpacing: 10),
                            itemCount:
                                getAllTreasureModel?.allTreasuresData?.length,
                            itemBuilder: (context, index) {
                              final thisTreasure =
                                  getAllTreasureModel?.allTreasuresData?[index];
                              return InkWell(
                                onTap: () {
                                  context.push(Routes.treasureDetails,
                                      extra: thisTreasure);
                                },
                                child: TreasurePostedCard(
                                  condition:
                                      thisTreasure?.condition?.name ?? 'N/A',
                                  imagePath: thisTreasure?.photos?.first,
                                  itemName: thisTreasure?.title ?? '',
                                  isCollected:
                                      (thisTreasure?.collectedAt?.isNotEmpty ??
                                              false) ||
                                          ((thisTreasure?.collectedBy?.id
                                                      ?.isNotEmpty ??
                                                  false) ||
                                              (thisTreasure?.collectedBy?.name
                                                      ?.isNotEmpty ??
                                                  false)),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                },
              ))),
    );
  }
}
