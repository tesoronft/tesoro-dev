import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_avatar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_notched_appbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/oro_rate_card.dart';
import 'package:tesoro_nft_app/custom_widgets/settings_central.dart';
import 'package:tesoro_nft_app/custom_widgets/settings_header.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (apis.userProfile == null) {
        await apis.getUserData(
          context.read<PreferencesProvider>().accessToken ?? '',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, apis, prefs, child) => CustomScaffold(
        backgroundColor:
            apis.isLoading ? AppColors.light.withAlpha(60) : AppColors.light,
        child: apis.isLoading
            ? SpinKitCircle(
                color: AppColors.primary,
              )
            : EasyRefresh.builder(
                onRefresh: () async {
                  await apis.getUserData(
                    prefs.accessToken ?? '',
                  );
                },
                childBuilder: (context, physics) => SingleChildScrollView(
                  physics: physics,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomNotchedAppbar(child: SizedBox()),
                          Positioned(
                              top: 60,
                              left: 160,
                              child: CustomAvatar(
                                  radius: 90,
                                  profileImage: apis
                                          .userProfile?.profileImage ??
                                      'https://e7.pngegg.com/pngimages/371/667/png-clipart-computer-icons-user-profile-encapsulated-postscript-icon-black-rectangle-black.png'))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 20,
                      ),
                      Center(
                        child: SettingsHeader(
                          earning: '\$${apis.userProfile?.tipReceived}',
                          location: apis.userProfile?.email ?? '',
                          name: apis.userProfile?.name ?? '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          height: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          AppStrings.tipsHistory,
                          style: AppTextStyles.headingMedium
                              .copyWith(color: AppColors.dark),
                        ),
                      ),
                      Center(
                        child: SettingsCentral(
                          givenAmount: '\$${apis.userProfile?.tipGiven}',
                          receivedAmount: '\$${apis.userProfile?.tipReceived}',
                          firstTitle: AppStrings.tipsReceived,
                          secondTitle: AppStrings.tipsGiven,
                          onFirstTap: () => context.push(Routes.tipsReceived),
                          onSecondTap: () => context.push(Routes.tipsGiven),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          AppStrings.treasureHistory,
                          style: AppTextStyles.headingMedium
                              .copyWith(color: AppColors.dark),
                        ),
                      ),
                      Center(
                        child: SettingsCentral(
                          receivedAmount:
                              '${apis.userProfile?.treasureCollected}',
                          givenAmount: '${apis.userProfile?.treasurePosted}',
                          firstTitle: AppStrings.collected,
                          secondTitle: AppStrings.posted,
                          onFirstTap: () =>
                              context.push(Routes.treasureCollected),
                          onSecondTap: () =>
                              context.push(Routes.treasurePosted),
                        ),
                      ),
                      // Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: OroRateCard(
                            convertedRate: '\$2,388.93 ',
                            usdAmount: '\$0.0119',
                            difference: ' -21.6%',
                            oroAvailable: '201M '),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomBtn(
                          text: AppStrings.earnOroTokens,
                          onBtnTap: () => context.push(Routes.oroPage),
                          trailingIcon: Icon(
                            Icons.arrow_forward,
                            color: AppColors.light,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: CustomBtn(
                      //     text: AppStrings.earnOroTokens,
                      //     onBtnTap: () async => await showAllDialogs(context),
                      //     trailingIcon: Icon(
                      //       Icons.arrow_forward,
                      //       color: AppColors.light,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
