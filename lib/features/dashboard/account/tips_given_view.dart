import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/tips_info.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/empty_view.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (apis.givenTipsModel == null) {
        apis.givenTipsData(
          context.read<PreferencesProvider>().userId ?? '',
          context.read<PreferencesProvider>().accessToken ?? '',
          1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, apis, prefs, child) => CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: AppStrings.tipsGiven,
          backgroundColor: AppColors.light,
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: apis.isLoading
                ? Center(
                    child: SpinKitCircle(
                      color: AppColors.primary,
                    ),
                  )
                : apis.givenTipsModel?.data.isEmpty ?? true
                    ? EmptyView(
                        title: 'Explore treasures to tip',
                      )
                    : Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: apis.givenTipsModel?.data.length,
                                  itemBuilder: (context, index) {
                                    final thisTip =
                                        apis.givenTipsModel?.data[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: TipsInfo(
                                          address: thisTip?.treasureData
                                                  ?.locationModel?.address ??
                                              'N/A',
                                          amountTitle: AppStrings.amountTipped,
                                          date: thisTip?.createdAt ?? 'N/A',
                                          totalAmount: '\$${thisTip?.amount}',
                                          userName:
                                              thisTip?.receiverData?.name ??
                                                  'N/A'),
                                    );
                                  }))
                        ],
                      ),
          )),
    );
  }
}
