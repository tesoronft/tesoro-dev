import 'dart:developer';

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
      final positions =
          await Provider.of<AppPermissions>(context, listen: false)
              .getCurrentPosition();
      final apis = Provider.of<ApiProvider>(context, listen: false);
      log('Here');
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

  ValueNotifier<String> availability = ValueNotifier<String>('Available');
  @override
  Widget build(BuildContext context) {
    return Consumer3<ApiProvider, AppPermissions, InternetChecker>(
      builder: (context, api, permissions, internet, child) => CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: AppStrings.treasurePosted,
          backgroundColor: AppColors.light,
          child: !internet.isConnected
              ? OfflineView()
              : SafeArea(
                  minimum: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: EasyRefresh.builder(
                    onRefresh: () async => await api.getAllTreasuresData(
                        1,
                        10,
                        'mine',
                        permissions.position?.longitude.toString() ?? '0.0',
                        permissions.position?.latitude.toString() ?? '0.0',
                        '10',
                        context.read<PreferencesProvider>().accessToken ?? ''),
                    childBuilder: (context, physics) => api.isLoading
                        ? ShimmerEffect()
                        : api.getAllTreasureModel?.allTreasuresData?.isEmpty ??
                                true
                            ? EmptyView(
                                title: AppStrings.postYourItem,
                                onTap: () => context.push(Routes.postTreasure),
                              )
                            : Stack(
                                children: [
                                  Column(
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
                                            itemCount: api.getAllTreasureModel
                                                ?.allTreasuresData?.length,
                                            itemBuilder: (context, index) {
                                              final thisTreasure = api
                                                  .getAllTreasureModel
                                                  ?.allTreasuresData?[index];
                                              return InkWell(
                                                onTap: () {
                                                  context.push(
                                                      Routes.treasureDetails,
                                                      extra: thisTreasure);
                                                },
                                                child: TreasurePostedCard(
                                                    condition: thisTreasure
                                                            ?.condition?.name ??
                                                        'N/A',
                                                    imagePath: thisTreasure
                                                        ?.photos?.first,
                                                    itemName:
                                                        thisTreasure?.title ??
                                                            ''),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                  !permissions.isLocationAllowed
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: PermissionEnableComponent())
                                      : SizedBox.shrink(),
                                ],
                              ),
                  ))),
    );
  }
}
