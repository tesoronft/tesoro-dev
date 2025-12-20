import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/custom_widgets/shimmer_effect.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../../../consts/app_colors.dart';
import '../../../../consts/app_strings.dart';
import '../../../../consts/app_text_styles.dart';
import '../../../../custom_widgets/custom_scaffold.dart';
import '../../../../custom_widgets/treasure_posted_card.dart';
import '../../../../providers/api_provider.dart';
import '../../../../providers/preferences_provider.dart';
import '../../../../utils/app_permissions.dart';

class AllTreasuresView extends StatefulWidget {
  const AllTreasuresView({super.key});

  @override
  State<AllTreasuresView> createState() => _AllTreasuresViewState();
}

class _AllTreasuresViewState extends State<AllTreasuresView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final positions = await AppPermissions.getCurrentPosition();
      longitude = positions?.longitude.toString();
      latitide = positions?.latitude.toString();
      final apis = Provider.of<ApiProvider>(context, listen: false);

      await apis.getAllTreasuresData(
          1,
          10,
          'all',
          positions != null ? positions.longitude.toString() : '67.0011',
          positions != null ? positions.latitude.toString() : '24.8607',
          '10',
          context.read<PreferencesProvider>().accessToken ?? '');
    });
  }

  String? longitude, latitide;
  ValueNotifier<int> rangeNotifier = ValueNotifier<int>(10);
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, api, child) => CustomScaffold(
          backgroundColor: AppColors.light,
          isAppbarRequired: true,
          appBarTitle: AppStrings.treasurePosted,
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: EasyRefresh.builder(
              onRefresh: () async => await api.getAllTreasuresData(
                  1,
                  10,
                  'all',
                  longitude ?? '67.0011',
                  latitide ?? '24.8607',
                  '10',
                  context.read<PreferencesProvider>().accessToken ?? ''),
              childBuilder: (context, physics) => ValueListenableBuilder(
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
                              10,
                              'all',
                              longitude ?? '67.0011',
                              latitide ?? '24.8607',
                              value.toInt().toString(),
                              context.read<PreferencesProvider>().accessToken ??
                                  '',
                            );
                          },
                        ),
                        api.isLoading
                            ? Expanded(child: ShimmerEffect())
                            : api.getAllTreasureModel == null
                                ? Center(
                                    child: Text(
                                      'No treasures available',
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(color: AppColors.dark),
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
                                          return GestureDetector(
                                            onTap: () => context.push(
                                                Routes.treasureDetails,
                                                extra: thisTreasure),
                                            child: TreasurePostedCard(
                                                condition:
                                                    thisTreasure?.condition ??
                                                        '',
                                                imagePath:
                                                    thisTreasure?.photos?.first,
                                                itemName:
                                                    thisTreasure?.title ?? ''),
                                          );
                                        }),
                                  ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
            ),
          )),
    );
  }
}
