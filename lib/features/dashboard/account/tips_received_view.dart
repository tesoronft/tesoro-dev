import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/tips_info.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/empty_view.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';

import '../../../models/tips/received_tips_model.dart';
import '../../../providers/preferences_provider.dart';

class TipsReceivedView extends StatefulWidget {
  const TipsReceivedView({super.key});

  @override
  State<TipsReceivedView> createState() => _TipsReceivedViewState();
}

class _TipsReceivedViewState extends State<TipsReceivedView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      await apis.receivedTipdData(
        prefs.userId ?? '',
        prefs.accessToken ?? '',
        1,
      );
      tipsReceivedResponse = apis.receivedTipsModel;
    });
  }

  ReceivedTipsResponse? tipsReceivedResponse;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, apis, prefs, child) => CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: AppStrings.tipsReceived,
          backgroundColor: AppColors.light,
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: EasyRefresh.builder(onRefresh: () async {
              await apis.receivedTipdData(
                prefs.userId ?? '',
                prefs.accessToken ?? '',
                1,
              );
              tipsReceivedResponse = apis.receivedTipsModel;
            }, onLoad: () async {
              final currectPage = apis.receivedTipsModel?.pagination.page ?? 1;
              final totalPages =
                  apis.receivedTipsModel?.pagination.totalPages ?? 1;
              if (currectPage < totalPages) {
                await apis.receivedTipdData(
                  prefs.userId ?? '',
                  prefs.accessToken ?? '',
                  currectPage + 1,
                );
                tipsReceivedResponse?.data
                    .addAll(apis.receivedTipsModel?.data ?? []);
              }
            }, childBuilder: (context, physics) {
              if (apis.isLoading) {
                return Center(
                  child: SpinKitCircle(
                    color: AppColors.primary,
                  ),
                );
              }

              if (tipsReceivedResponse?.data == null) {
                return SizedBox();
              }

              if (tipsReceivedResponse?.data.isEmpty ?? true) {
                return EmptyView(
                  title: 'Explore treasures to tip',
                );
              }
              // if (internet.isConnected == false) {
              //   return OfflineView();
              // }
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: tipsReceivedResponse?.data.length,
                          physics: physics,
                          itemBuilder: (context, index) {
                            final thisTip = tipsReceivedResponse?.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TipsInfo(
                                  address: thisTip?.treasureData?.locationModel
                                          ?.address ??
                                      'N/A',
                                  amountTitle: AppStrings.amountReceived,
                                  date: DateTime.tryParse(
                                              thisTip?.createdAt ?? '')
                                          ?.toLocal()
                                          .toString() ??
                                      'N/A',
                                  totalAmount: '${thisTip?.amount}',
                                  userName:
                                      thisTip?.receiverData?.name ?? 'N/A'),
                            );
                          }))
                ],
              );
            }),
          )),
    );
  }
}
