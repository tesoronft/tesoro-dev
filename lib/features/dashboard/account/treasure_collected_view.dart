import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/treasure_collected_card.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/empty_view.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

import '../../../custom_widgets/permission_enable_component.dart';
import '../../../custom_widgets/shimmer_effect.dart';
import '../../../utils/app_permissions.dart';

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
      if (apis.allCollectedTreasure?.listOfPostedTreasures?.isEmpty ?? true) {
        await apis.getTreasureCollectedByUser(
            1,
            context.read<PreferencesProvider>().accessToken ?? '',
            context.read<PreferencesProvider>().userId ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, AppPermissions>(
      builder: (context, apis, permissions, child) => CustomScaffold(
        isAppbarRequired: true,
        appBarTitle: AppStrings.treasureCollected,
        backgroundColor: AppColors.light,
        child: SafeArea(
          minimum: EdgeInsets.all(10),
          child: apis.isLoading
              ? ShimmerEffect()
              : apis.allCollectedTreasure?.listOfPostedTreasures?.isEmpty ??
                      true
                  ? EmptyView()
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: apis.allCollectedTreasure
                                    ?.listOfPostedTreasures?.length,
                                itemBuilder: (context, index) {
                                  final thisCollection = apis
                                      .allCollectedTreasure
                                      ?.listOfPostedTreasures?[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: TreasureCollectedCard(
                                      date:
                                          thisCollection?.collectedAt ?? 'N/A',
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
                            ),
                          ],
                        ),
                        !permissions.isLocationAllowed
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: PermissionEnableComponent())
                            : SizedBox.shrink(),
                      ],
                    ),
        ),
      ),
    );
  }
}
