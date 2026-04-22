import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/tips_info.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/empty_view.dart';

import '../../../models/tips/sended_tips_model.dart';
import '../../../providers/api_provider.dart';
import '../../../providers/preferences_provider.dart';

class TipsGivenView extends StatefulWidget {
  const TipsGivenView({super.key});

  @override
  State<TipsGivenView> createState() => _TipsGivenViewState();
}

class _TipsGivenViewState extends State<TipsGivenView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      await apis.givenTipsData(
        prefs.userId ?? '',
        prefs.accessToken ?? '',
        1,
      );
      tipsGivenResponse = apis.givenTipsModel;
    });
  }

  SendedTipsResponse? tipsGivenResponse;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, apis, prefs, child) => CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: AppStrings.tipsGiven,
          backgroundColor: AppColors.light,
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: EasyRefresh.builder(onRefresh: () async {
              await apis.givenTipsData(
                prefs.userId ?? '',
                prefs.accessToken ?? '',
                1,
              );
              tipsGivenResponse = apis.givenTipsModel;
            }, onLoad: () async {
              final currectPage = apis.givenTipsModel?.pagination.page ?? 1;
              final totalPages =
                  apis.givenTipsModel?.pagination.totalPages ?? 1;
              if (currectPage < totalPages) {
                await apis.givenTipsData(
                  prefs.userId ?? '',
                  prefs.accessToken ?? '',
                  currectPage + 1,
                );
                tipsGivenResponse?.data.addAll(apis.givenTipsModel?.data ?? []);
              }
            }, childBuilder: (context, physics) {
              if (apis.isLoading) {
                return Center(
                  child: SpinKitCircle(
                    color: AppColors.primary,
                  ),
                );
              }

              if (tipsGivenResponse?.data == null) {
                return SizedBox();
              }

              if (tipsGivenResponse?.data.isEmpty ?? true) {
                return EmptyView(
                  title: 'Explore treasures to tip',
                );
              }

              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: tipsGivenResponse?.data.length,
                          physics: physics,
                          itemBuilder: (context, index) {
                            final thisTip = tipsGivenResponse?.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TipsInfo(
                                  address: thisTip?.treasureData?.locationModel
                                          ?.address ??
                                      'N/A',
                                  amountTitle: AppStrings.amountTipped,
                                  date: thisTip?.createdAt ?? 'N/A',
                                  totalAmount: '\$${thisTip?.amount}',
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
