import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/custom_widgets/treasure_collected_card.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

class TreasureCollectedView extends StatefulWidget {
  const TreasureCollectedView({super.key});

  @override
  State<TreasureCollectedView> createState() => _TreasureCollectedViewState();
}

class _TreasureCollectedViewState extends State<TreasureCollectedView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (apis.allCollectedTreasure == null) {
        await apis.getTreasureCollectedByUser(
            1,
            context.read<PreferencesProvider>().accessToken ?? '',
            context.read<PreferencesProvider>().userId ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, apis, child) => CustomScaffold(
        backgroundColor:
            apis.isLoading ? AppColors.light.withAlpha(60) : AppColors.light,
        child: SafeArea(
          minimum: EdgeInsets.all(10),
          child: apis.isLoading
              ? Center(
                  child: SpinKitCircle(
                    color: AppColors.primary,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupButton(),
                        Text(
                          AppStrings.treasureCollected,
                          style: AppTextStyles.headingMedium,
                        ),
                        SizedBox.shrink()
                      ],
                    ),
                    apis.allCollectedTreasure?.listOfPostedTreasures == []
                        ? Center(
                            child: Text(
                              'No treasure collected yet',
                              style: AppTextStyles.bodyMedium,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: apis.allCollectedTreasure
                                  ?.listOfPostedTreasures?.length,
                              itemBuilder: (context, index) {
                                final thisCollection = apis.allCollectedTreasure
                                    ?.listOfPostedTreasures?[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TreasureCollectedCard(
                                    date: thisCollection?.collectedAt ?? 'N/A',
                                    imageUrl: thisCollection?.photos?.first,
                                    itemName: thisCollection?.title ?? 'N/A',
                                    location: thisCollection
                                            ?.locationModel?.address ??
                                        'N/A',
                                    personName:
                                        thisCollection?.postedBy?.userName ??
                                            'N/A',
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
