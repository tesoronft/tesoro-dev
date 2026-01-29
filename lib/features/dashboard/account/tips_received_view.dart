import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/tips_info.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/empty_view.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/internet_checker.dart';

import '../../../providers/preferences_provider.dart';
import '../../others/offline_view.dart';

class TipsReceivedView extends StatefulWidget {
  const TipsReceivedView({super.key});

  @override
  State<TipsReceivedView> createState() => _TipsReceivedViewState();
}

class _TipsReceivedViewState extends State<TipsReceivedView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (apis.receivedTipsModel == null) {
        await apis.receivedTipdData(
            context.read<PreferencesProvider>().userId ?? '',
            context.read<PreferencesProvider>().accessToken ?? '',
            1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, InternetChecker>(
      builder: (context, apis, internet, child) => CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: AppStrings.tipsReceived,
          backgroundColor: AppColors.light,
          child: !internet.isConnected
              ? OfflineView()
              : SafeArea(
                  minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: apis.isLoading
                      ? Center(
                          child: SpinKitCircle(
                            color: AppColors.primary,
                          ),
                        )
                      : apis.receivedTipsModel?.data.isEmpty ?? true
                          ? EmptyView(
                              title: 'Add more items to receive tips',
                              onTap: () => context.push(Routes.postTreasure),
                            )
                          : Column(
                              children: [
                                Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            apis.receivedTipsModel?.data.length,
                                        itemBuilder: (context, index) {
                                          final thisTip = apis
                                              .receivedTipsModel?.data[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: TipsInfo(
                                                address: thisTip
                                                        ?.treasureData
                                                        ?.locationModel
                                                        ?.address ??
                                                    'N/A',
                                                amountTitle:
                                                    AppStrings.amountReceived,
                                                date: DateTime.tryParse(thisTip
                                                                ?.createdAt ??
                                                            '')
                                                        ?.toLocal()
                                                        .toString() ??
                                                    'N/A',
                                                totalAmount:
                                                    '\$${thisTip?.amount}',
                                                userName: thisTip
                                                        ?.receiverData?.name ??
                                                    'N/A'),
                                          );
                                        }))
                              ],
                            ),
                )),
    );
  }
}
