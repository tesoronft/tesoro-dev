import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/data/subscription/subscription_data.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class SubscriptionFirstView extends StatelessWidget {
  const SubscriptionFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => ListTile(),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: SubscriptionData.images.length),
            ),
            CustomBtn(
              text: AppStrings.goPremium,
              onBtnTap: () => context.push(
                Routes.subscriptionViewTwo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
